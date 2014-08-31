require "spec_helper"
  
describe TranslatedContentPage do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
    
  describe ".add_translation_content_page" do
    let(:user) { User.first }
    let(:content_page) { ContentPage.gen }
    subject(:translated_content_page) { TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, language.id) }
    let(:language) { Language.english }
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, sync_object_id: content_page.id)
        parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
          left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description", 
          active_translation: 1 , created_at: Time.now}
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "adds new translation to content page" do
        expect(translated_content_page).not_to be_nil          
      end
      it "responds to 'language'" do
        expect(translated_content_page.language_id).to eq(language.id)
      end
      it "responds to 'title'" do
        expect(translated_content_page.title).to eq("title")
      end
      it "responds to 'main_content'" do
        expect(translated_content_page.main_content).to eq("main_content")
      end
      it "responds to 'left_content'" do
        expect(translated_content_page.left_content).to eq("left_content")
      end
      it "responds to 'meta_keywords'" do
        expect(translated_content_page.meta_keywords).to eq("meta_keywords")
      end
      it "responds to 'meta_description'" do
        expect(translated_content_page.meta_description).to eq("meta_description")
      end
      it "responds to 'active_translation'" do
        expect(translated_content_page.active_translation).to eq(1)
      end
      it "updates content page" do
        expect(content_page.last_update_user_id).to eq(user.id)
      end
      after(:all) do
        translated_content_page.destroy if translated_content_page
        content_page.destroy if content_page
      end
    end
    
    context "when creation fails because there is a newer creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
        @local_translated_content_page = TranslatedContentPage.gen(content_page: content_page, language: Language.english)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                      user_site_object_id: user.origin_id, sync_object_id: content_page.id)
        parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
          left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description", 
          active_translation: 1 , created_at: @local_translated_content_page.created_at - 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "doesn't create translated content page" do
        expect(translated_content_page.id).to eq(@local_translated_content_page.id)
      end
      after(:all) do
        translated_content_page.destroy if translated_content_page
        content_page.destroy if content_page
        @local_translated_content_page.destroy if @local_translated_content_page
      end
    end
  end
  
  describe ".update_translated_content_page" do
    let(:content_page) { ContentPage.gen }
    subject(:translated_content_page) { TranslatedContentPage.gen(content_page: content_page, language: Language.english) } 
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user = User.first
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                      user_site_object_id: user.origin_id, sync_object_id: content_page.id)
        parameters_values_hash = { language_id: translated_content_page.language.id, title: "new title",
          main_content: "main_content", left_content: "left_content", meta_keywords: "meta_keywords",
          meta_description: "meta_description", active_translation: 1, updated_at: Time.now }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        translated_content_page.reload
      end
      it "updates title of translated content page" do
        expect(translated_content_page.title).to eq("new title")
      end
      it "updates main_content of translated content page" do
        expect(translated_content_page.main_content).to eq("main_content")
      end
      it "updates left_content of translated content page" do
        expect(translated_content_page.left_content).to eq("left_content")
      end
      it "updates meta_keywords of translated content page" do
        expect(translated_content_page.meta_keywords).to eq("meta_keywords")
      end
      it "updates meta_description of translated content page" do
        expect(translated_content_page.meta_description).to eq("meta_description")
      end
      after(:all) do
        translated_content_page.destroy if translated_content_page
        content_page.destroy if content_page
      end
    end
    
   #TODO handle pull failures  
    context "when update fails because the translated content page isn't found" do
    end
  end
  
  describe ".delete_translated_content_page" do
    let(:translated_content_page) { TranslatedContentPage.gen(content_page: content_page, language: Language.english, title: "Test Content Page") }
    subject(:content_page) { ContentPage.gen }
    let(:language) { Language.english }
    context "when successful deletion" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user = User.first
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                      user_site_object_id: user.origin_id, sync_object_id: content_page.id)
        parameters_values_hash = { language_id: translated_content_page.language.id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "deletes translated content page" do
        deleted_translated_content_page = TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, language.id)
        expect(deleted_translated_content_page).to be_nil
      end
      it "archives deleted translated content page" do
        archived_translated_content_page = TranslatedContentPageArchive.find_by_content_page_id_and_language_id(content_page.id, language.id)
        expect(archived_translated_content_page.title).to eq("Test Content Page")
      end
      after(:all) do
        translated_content_page.destroy if translated_content_page
        content_page.destroy if content_page
      end
    end
    
   #TODO handle pull failures  
    context "when update fails because the translated content page isn't found" do
    end
  end
end