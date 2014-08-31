require "spec_helper"
  
describe SyncPeerLog do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_content_page" do
    let(:user) { User.first }
    subject(:content_page) { ContentPage.find_site_specific(100, PEER_SITE_ID) }
    let(:language) { Language.english }
    let(:translated_content_page) { TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, language.id) }
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: 100, sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
          left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description", 
          active_translation: 1, page_name: "page_name", active: "1", sort_order: "1", created_at: Time.now }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new content page" do
        expect(content_page).not_to be_nil          
      end
      
      it "has correct 'active'" do
        expect(content_page.active).to eq(true)
      end
      
      it "has correct 'sort_order'" do
        expect(content_page.sort_order).to eq(1)
      end
      
      it "has correct 'page_name'" do
        expect(content_page.page_name).to eq("page_name")
      end
      
      it "has correct 'last_update_user_id'" do
        expect(content_page.last_update_user_id).to eq(user.id)
      end
      
      it "creates new translated content page" do
        expect(translated_content_page).not_to be_nil          
      end
      
      it "has correct 'title' for translated_content_page" do
        expect(translated_content_page.title).to eq("title")
      end
      
      it "correct 'main_content' for translated_content_page" do
        expect(translated_content_page.main_content).to eq("main_content")
      end
      
      it "has correct 'left_content' for translated_content_page" do
        expect(translated_content_page.left_content).to eq("left_content")
      end
      
      it "has correct 'meta_keywords' for translated_content_page" do
        expect(translated_content_page.meta_keywords).to eq("meta_keywords")
      end
      
      it "has correct 'meta_description' for translated_content_page" do
        expect(translated_content_page.meta_description).to eq("meta_description")
      end
      
      it "has correct 'active_translation' for translated_content_page" do
        expect(translated_content_page.active_translation).to eq(1)
      end
      
      after(:all) do
        content_page.destroy if content_page
        translated_content_page.destroy if translated_content_page
      end
    end
    # last create wins
    context "when creation fails because there is a newer creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        @local_content_page = ContentPage.gen(page_name: "page_name")
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: 100, sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
          left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description", 
          active_translation: 1, page_name: "page_name", active: "1", sort_order: "1",
          created_at: @local_content_page.created_at - 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      
      it "doesn't create new content page with the same name" do
        expect(content_page).to be_nil
      end
      after(:all) do
        @local_content_page.destroy if @local_content_page
      end
    end
  end
  
  describe ".update_content_page" do
    let(:user) { User.first }
    subject(:content_page) { ContentPage.first }
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { page_name: "page_name", active: "1", updated_at: content_page.updated_at + 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        content_page.reload
      end
              
      it "updates 'page_name'" do
        expect(content_page.page_name).to eq("page_name")
      end
    end
    
    context "when update fails because there is a newer update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID,
                                       page_name: "name", updated_at: Time.now)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { page_name: "page_name", active: "1", updated_at: content_page.updated_at - 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        content_page.reload
      end
      
      it "doesn't update 'page_name'" do
        expect(content_page.page_name).to eq("name")
      end
    end
  end
  
  describe ".delete_content_page" do
    let(:user) { User.first }
    subject(:content_page) { ContentPage.gen }
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
        @id = content_page.id
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        sync_peer_log.process_entry
      end
              
      it "deletes content page" do
        expect(ContentPage.find_site_specific(@id, PEER_SITE_ID)).to be_nil
      end
    end
  end
  
  describe ".swap_content_page 'move_down'" do
    let(:user) { User.first }
    subject(:content_page) { ContentPage.first }
    let(:lower_page) { ContentPage.gen(parent_content_page_id: "", page_name: "lower_page",
                                       active: "1", sort_order: 2) }
    context "when successful swap" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, 
                                       sort_order: 1, swap_updated_at: Time.now)
        lower_page.update_attributes(origin_id: lower_page.id, site_id: PEER_SITE_ID,
                                     swap_updated_at: Time.now)
        content_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        content_page_parameters_values_hash = { content_page_sort_order: lower_page.sort_order,
                                                updated_at: content_page.swap_updated_at + 2 }
        create_log_action_parameters(content_page_parameters_values_hash, content_page_sync_peer_log)
        
        swap_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: lower_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        swap_page_parameters_values_hash = { content_page_sort_order: content_page.sort_order,
                                             updated_at: lower_page.swap_updated_at + 2 }
        create_log_action_parameters(swap_page_parameters_values_hash, swap_page_sync_peer_log)
        
        content_page_sync_peer_log.process_entry
        content_page.reload
        swap_page_sync_peer_log.process_entry
        lower_page.reload
      end
              
      it "decreases sort order of content page" do
        expect(content_page.sort_order).to eq(2)
      end
      
      it "increases sort order of lower page" do
        expect(lower_page.sort_order).to eq(1)
      end
      
      after(:all) do
        lower_page.destroy if lower_page
      end
    end
  end
  
  describe ".swap_content_page 'move_up'" do
    let(:user) { User.first }
    subject(:content_page) { ContentPage.first }
    let(:upper_page) { ContentPage.gen(parent_content_page_id: "", page_name: "upper_page",
                                       active: "1", sort_order: 1) }
    context "when successful swap" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, 
                                       sort_order: 2, swap_updated_at: Time.now)
        upper_page.update_attributes(origin_id: upper_page.id, site_id: PEER_SITE_ID,
                                     swap_updated_at: Time.now)
        content_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        content_page_parameters_values_hash = { content_page_sort_order: upper_page.sort_order,
                                                updated_at: content_page.swap_updated_at + 2 }
        create_log_action_parameters(content_page_parameters_values_hash, content_page_sync_peer_log)
        
        swap_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                      sync_object_id: upper_page.origin_id, sync_object_site_id: PEER_SITE_ID)
        swap_page_parameters_values_hash = { content_page_sort_order: content_page.sort_order,
                                             updated_at: upper_page.swap_updated_at + 2 }
        create_log_action_parameters(swap_page_parameters_values_hash, swap_page_sync_peer_log)
        
        content_page_sync_peer_log.process_entry
        content_page.reload
        swap_page_sync_peer_log.process_entry
        upper_page.reload
      end
              
      it "increases sort order of content page" do
        expect(content_page.sort_order).to eq(1)
      end
      
      it "decreases sort order of upper page" do
        expect(upper_page.sort_order).to eq(2)
      end
      
      after(:all) do
        upper_page.destroy if upper_page
      end
    end
  end
end