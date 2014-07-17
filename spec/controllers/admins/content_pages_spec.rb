require File.dirname(__FILE__) + '/../../spec_helper'

describe Admins::ContentPagesController do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    @admin = User.gen
    @admin.grant_admin
    @cms_user = User.gen
    @cms_user.grant_permission(:edit_cms)
    @normal_user = User.gen
  end

  before(:each) do
    session[:user_id] = nil
  end

  it 'should redirect non-logged-in users to a login page' do
    session[:user_id] = nil
    get :index
    expect(response).to redirect_to(login_url)
  end

  it 'should raise SecurityViolation for average_users' do
    session[:user_id] = @normal_user.id
    expect { get :index }.to raise_error(EOL::Exceptions::SecurityViolation)
  end

  it 'should not raise error for admins or CMS viewers' do
    session[:user_id] = @admin.id
    expect { get :index }.not_to raise_error
    session[:user_id] = @cms_user.id
    expect { get :index }.not_to raise_error
  end
  
  describe "synchronization" do
    
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:content_page) { ContentPage.last }
      let(:parent_content_page) { ContentPage.first }
      
      context "successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = @admin.id
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          parent_content_page.update_attributes(origin_id: parent_content_page.id, site_id: PEER_SITE_ID)
          post :create ,{ content_page: { parent_content_page_id: parent_content_page.id, page_name: "test5", active: "1" }, 
                          translated_content_page: { language_id: "#{Language.first.id}", 
                                                     title: "test5", 
                                                     main_content: "<p>hello5</p>\r\n", 
                                                     left_content: "left_content", 
                                                     meta_keywords: "meta_keywords",
                                                     meta_description: "meta_description", 
                                                     active_translation: "1" }}
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.origin_id)
        end
      
        it "creates sync log action parameter for 'title'" do
          title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
          expect(title_parameter[0][:value]).to eq("test5")
        end
        
        it "creates sync log action parameter for 'page_name'" do
          page_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "page_name")
          expect(page_name_parameter[0][:value]).to eq("test5")
        end
        
        it "creates sync log action parameter for 'main_content'" do
          main_content_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "main_content")
          expect(main_content_parameter[0][:value]).to eq("<p>hello5</p>\r\n")
        end
        
        it "creates sync log action parameter for 'left_content'" do
          left_content_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "left_content")
          expect(left_content_parameter[0][:value]).to eq("left_content")
        end
        
        it "creates sync log action parameter for 'meta_keywords'" do
          meta_keywords_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "meta_keywords")
          expect(meta_keywords_parameter[0][:value]).to eq("meta_keywords")
        end
        
        it "creates sync log action parameter for 'meta_description'" do
          meta_description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "meta_description")
          expect(meta_description_parameter[0][:value]).to eq("meta_description")
        end
        
        it "creates sync log action parameter for 'active_translation'" do
          active_translation_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "active_translation")
          expect(active_translation_parameter[0][:value]).to eq("1")
        end
        
        it "creates sync log action parameter for 'active'" do
          active_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "active")
          expect(active_parameter[0][:value]).to eq("1")
        end
        
        it "creates sync log action parameter for 'parent_content_page_origin_id'" do
          parent_content_page_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "parent_content_page_origin_id")
          expect(parent_content_page_origin_id_parameter[0][:value].to_i).to eq(parent_content_page.origin_id)
        end
        
        it "creates sync log action parameter for 'parent_content_page_site_id'" do
          parent_content_page_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "parent_content_page_site_id")
          expect(parent_content_page_site_id_parameter[0][:value].to_i).to eq(parent_content_page.site_id)
        end
         after(:each) do
          content_page.destroy if content_page
        end
      end
      
      context "user has no privileges to create content page" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          parent_content_page.update_attributes(origin_id: parent_content_page.id, site_id: PEER_SITE_ID)
          post :create ,{ content_page: { parent_content_page_id: parent_content_page.id, page_name: "test5", active: "1" }, 
                          translated_content_page: { language_id: "#{Language.first.id}", 
                                                     title: "test5", 
                                                     main_content: "<p>hello5</p>\r\n", 
                                                     left_content: "left_content", 
                                                     meta_keywords: "meta_keywords",
                                                     meta_description: "meta_description", 
                                                     active_translation: "1" }}

        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:content_page) { ContentPage.last }
      let(:parent_content_page) { ContentPage.first }
      
      context "successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = @admin.id
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          parent_content_page.update_attributes(origin_id: parent_content_page.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, page_name: "old_title")
          put :update ,{ content_page: { parent_content_page_id: parent_content_page.id, 
                                         page_name: "new title", active: "1" }, 
                         id: content_page}
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.origin_id)
        end
        
        it "creates sync log action parameter for 'page_name'" do
          page_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "page_name")
          expect(page_name_parameter[0][:value]).to eq("new title")
        end
        
        it "creates sync log action parameter for 'active'" do
          active_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "active")
          expect(active_parameter[0][:value]).to eq("1")
        end
        
        it "creates sync log action parameter for 'parent_content_page_origin_id'" do
          parent_content_page_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "parent_content_page_origin_id")
          expect(parent_content_page_origin_id_parameter[0][:value].to_i).to eq(parent_content_page.origin_id)
        end
        
        it "creates sync log action parameter for 'parent_content_page_site_id'" do
          parent_content_page_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "parent_content_page_site_id")
          expect(parent_content_page_site_id_parameter[0][:value].to_i).to eq(parent_content_page.site_id)
        end
      end
      
      context "user has no privileges to create content page" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          parent_content_page.update_attributes(origin_id: parent_content_page.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, page_name: "old_title")
          put :update ,{ content_page: { parent_content_page_id: parent_content_page.id, 
                                         page_name: "new title", active: "1" }, 
                         id: content_page}

        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "DESTROY #delete" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:content_page) { ContentPage.gen }
      
      context "successful deletion" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = @admin.id
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          delete :destroy , { id: content_page.id }
        end
        
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.origin_id)
        end
      end
      
      context "user has no privileges to delete content page" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          delete :destroy , { id: content_page.id }

        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "POST #move_down" do
      let(:content_page_peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.swap.id, SyncObjectType.content_page.id,
                                          content_page.origin_id, PEER_SITE_ID).first }
      let(:lower_page_peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.swap.id, SyncObjectType.content_page.id,
                                          lower_page.origin_id, PEER_SITE_ID).first }
      subject(:content_page) { ContentPage.first }
      let(:lower_page) { ContentPage.gen(parent_content_page_id: "", page_name: "lower_page",
                                         active: "1", sort_order: 2) }
      
      context "successful move down" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = @admin.id
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          lower_page.update_attributes(origin_id: lower_page.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, sort_order: 1)                                           
          post :move_down , { id: content_page.id }
        end
        
        it "creates sync peer log" do
          expect(content_page_peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(content_page_peer_log.sync_object_action_id).to eq(SyncObjectAction.swap.id)
        end
        
        it "has correct type" do
          expect(content_page_peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(content_page_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(content_page_peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(content_page_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(content_page_peer_log.sync_object_id).to eq(content_page.origin_id)
        end
        
        it "creates sync log action parameter for 'content_page_sort_order'" do
          content_page_sort_order_parameter = SyncLogActionParameter.where(peer_log_id: content_page_peer_log.id, parameter: "content_page_sort_order")
          expect(content_page_sort_order_parameter[0][:value].to_i).to eq(lower_page.sort_order)
        end
        
        it "creates sync log action parameter for 'updated_at'" do
          updated_at_parameter = SyncLogActionParameter.where(peer_log_id: content_page_peer_log.id, parameter: "updated_at")
          expect(updated_at_parameter[0][:value]).to eq(content_page.swap_updated_at.utc.to_s(:db))
        end
        
        it "creates sync peer log for lower page" do
          expect(lower_page_peer_log).not_to be_nil
        end
        
        it "has correct action for lower page" do
          expect(lower_page_peer_log.sync_object_action_id).to eq(SyncObjectAction.swap.id)
        end
        
        it "has correct type for lower page" do
          expect(lower_page_peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID' for lower page" do
          expect(lower_page_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id' for lower page" do
          expect(lower_page_peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        
        it "has correct 'object_site_id' for lower page" do
          expect(lower_page_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id' for lower page" do
          expect(lower_page_peer_log.sync_object_id).to eq(lower_page.origin_id)
        end
        
        it "creates sync log action parameter for 'content_page_sort_order' for lower page" do
          content_page_sort_order_parameter = SyncLogActionParameter.where(peer_log_id: lower_page_peer_log.id, parameter: "content_page_sort_order")
          expect(content_page_sort_order_parameter[0][:value].to_i).to eq(content_page.sort_order)
        end
        
        it "creates sync log action parameter for 'updated_at' for lower page" do
          updated_at_parameter = SyncLogActionParameter.where(peer_log_id: lower_page_peer_log.id, parameter: "updated_at")
          expect(updated_at_parameter[0][:value]).to eq(lower_page.swap_updated_at.utc.to_s(:db))
        end
        
        after do
          lower_page.destroy if lower_page
        end
      end
      
      context "user has no privileges to move down content page" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          lower_page = ContentPage.gen(parent_content_page_id: "", page_name: "lower_page", active: "1", sort_order: 2)
          lower_page.update_attributes(origin_id: lower_page.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, sort_order: 1)                                           
          post :move_down , { id: content_page.id }

        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "POST #move_up" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:content_page) { ContentPage.first }
      let(:upper_page) { ContentPage.gen(parent_content_page_id: "", page_name: "lower_page", active: "1",
                                         sort_order: 1) }
      
      context "successful move up" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = @admin.id
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          upper_page.update_attributes(origin_id: upper_page.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, sort_order: 2)                                           
          post :move_up , { id: content_page.id }
        end
        
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.swap.id)
        end
        
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.origin_id)
        end
        
        it "creates sync log action parameter for 'swap_page_origin_id'" do
          swap_page_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "swap_page_origin_id")
          expect(swap_page_origin_id_parameter[0][:value].to_i).to eq(upper_page.origin_id)
        end
        
        it "creates sync log action parameter for 'swap_page_site_id'" do
          swap_page_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "swap_page_site_id")
          expect(swap_page_site_id_parameter[0][:value].to_i).to eq(upper_page.site_id)
        end
        
        it "creates sync log action parameter for 'swap_page_sort_order'" do
          swap_page_sort_order_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "swap_page_sort_order")
          expect(swap_page_sort_order_parameter[0][:value].to_i).to eq(content_page.sort_order)
        end
        
        it "creates sync log action parameter for 'content_page_sort_order'" do
          content_page_sort_order_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "content_page_sort_order")
          expect(content_page_sort_order_parameter[0][:value].to_i).to eq(upper_page.sort_order)
        end
        after(:each) do
          upper_page.destroy if upper_page
        end
      end
      
      context "user has no privileges to move up content page" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          lower_page = ContentPage.gen(parent_content_page_id: "", page_name: "lower_page", active: "1", sort_order: 2)
          lower_page.update_attributes(origin_id: lower_page.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, sort_order: 1)                                           
          post :move_down , { id: content_page.id }

        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
  end
end