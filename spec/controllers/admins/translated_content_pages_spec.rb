require File.dirname(__FILE__) + '/../../spec_helper'

describe Admins::TranslatedContentPagesController do
  before(:all) do
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    @admin = User.gen
    @admin.grant_admin
    @cms_user = User.gen
    @cms_user.grant_permission(:edit_cms)
    @normal_user = User.gen
  end

  let(:content_page) { ContentPage.gen }

  before(:each) do
    session[:user_id] = nil
  end

  it 'should redirect non-logged-in users to a login page' do
    session[:user_id] = nil
    get :new
    expect(response).to redirect_to(login_url)
  end

  it 'should raise SecurityViolation for average_users' do
    session[:user_id] = @normal_user.id
    expect { get :new }.to raise_error(EOL::Exceptions::SecurityViolation)
  end

  it 'should not raise an error for admins or CMS viewers' do
    session[:user_id] = @admin.id
    expect { get :new, content_page_id: content_page.id }.not_to raise_error
    session[:user_id] = @cms_user.id
    expect { get :new, content_page_id: content_page.id }.not_to raise_error
  end
  
  describe "synchronization" do
    before(:all) do
      content_page.update_attributes(site_id: PEER_SITE_ID, origin_id: content_page.id)
      @admin.update_attributes(site_id: PEER_SITE_ID, origin_id: @admin.id)
    end
    describe "POST #create" do
     
     let(:peer_log) {SyncPeerLog.first} 
     
      context "successful creation" do
        before do
          session[:user_id] = @admin.id
          post :create, {translated_content_page: {language_id: "3", title: "translated content page", 
                                                   main_content: "<p>main_content</p>\r\n", 
                                                   left_content: "left_content", meta_keywords: "meta_keywords",
                                                   meta_description: "meta_description", active_translation: "1"},
                         content_page_id: content_page.id}
                         
        end

        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "action of sync peer log is 'create'" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.add_translation.id)
        end
        
        it "type of sync peer log is 'content_page'" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "sync peer log 'user_id' equal 'admin_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.id)
        end
        
        it "sync peer log 'object_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "sync peer log 'object_id' equal 'content_page_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.id)
        end
        
        it "creates sync log action parameter for 'language_id'" do
          language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
          expect(language_id_parameter[0][:value]).to eq("3")
        end
        
        it "creates sync log action parameter for 'title'" do
          title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
          expect(title_parameter[0][:value]).to eq("translated content page")
        end
        
        it "creates sync log action parameter for 'main_content'" do
          main_content_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "main_content")
          expect(main_content_parameter[0][:value]).to eq("<p>main_content</p>\r\n")
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
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
        
      end
      context "when user have no privileges to create content page" do
        before do
          post :create, {content_page_id: content_page.id, translated_content_page: {language_id: "3", title: "translated content page", 
                                                   main_content: "<p>main_content</p>\r\n", 
                                                   left_content: "left_content", meta_keywords: "meta_keywords",
                                                   meta_description: "meta_description", active_translation: "1"}}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
      
      context "invalid content pages parameters: missing body" do
        before(:each) do
          session[:user_id] = @admin.id
          post :create, {translated_content_page: {language_id: "3", title: "translated content page", 
                                                   left_content: "left_content", meta_keywords: "meta_keywords",
                                                   meta_description: "meta_description", active_translation: "1"},
                         content_page_id: content_page.id}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
      
      context "invalid content pages parameters: missing title" do
        before(:each) do
          session[:user_id] = @admin.id
          post :create, {translated_content_page: {language_id: "3",
                                                   main_content: "<p>main_content</p>\r\n", 
                                                   left_content: "left_content", meta_keywords: "meta_keywords",
                                                   meta_description: "meta_description", active_translation: "1"},
                         content_page_id: content_page.id}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
    end
    
    describe "PUT #update" do
     
     let(:peer_log) {SyncPeerLog.first} 
     subject(:translated_content_page) {TranslatedContentPage.gen(content_page: content_page)} 
     
      context "successful update" do
        before(:each) do
          session[:user_id] = @admin.id
          put :update, {content_page: {last_update_user_id: @admin.id}, 
                        translated_content_page: {title: "new title", main_content: "<p>main_content</p>\r\n",
                                                 left_content: "left_content", meta_keywords: "meta_keywords", 
                                                 meta_description: "meta_description", active_translation: "1"},
                        content_page_id: content_page.id, id: translated_content_page.id}
        end

        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "action of sync peer log is 'create'" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        
        it "type of sync peer log is 'content_page'" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.translated_content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "sync peer log 'user_id' equal 'admin_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.id)
        end
        
        it "sync peer log 'object_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "sync peer log 'object_id' equal 'content_page_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.id)
        end
        
        it "creates sync log action parameter for 'language_id'" do
          language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
          expect(language_id_parameter[0][:value]).to eq("#{translated_content_page.language_id}")
        end
        
        it "creates sync log action parameter for 'title'" do
          title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
          expect(title_parameter[0][:value]).to eq("new title")
        end
        
        it "creates sync log action parameter for 'main_content'" do
          main_content_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "main_content")
          expect(main_content_parameter[0][:value]).to eq("<p>main_content</p>\r\n")
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
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
        
      end
      context "failed update: user havn't privilige to update content page" do
        before(:each) do
          put :update, {content_page: {last_update_user_id: @admin.id}, 
                        translated_content_page: {title: "new title", main_content: "<p>main_content</p>\r\n",
                                                 left_content: "left_content", meta_keywords: "meta_keywords", 
                                                 meta_description: "meta_description", active_translation: "1"},
                        content_page_id: content_page.id, id: translated_content_page.id}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
      
      context "failed update: missing title" do
        before(:each) do
          session[:user_id] = @admin.id
          put :update, {content_page: {last_update_user_id: @admin.id}, 
                        translated_content_page: {title: "", main_content: "<p>main_content</p>\r\n",
                                                 left_content: "left_content", meta_keywords: "meta_keywords", 
                                                 meta_description: "meta_description", active_translation: "1"},
                        content_page_id: content_page.id, id: translated_content_page.id}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
      
      context "failed update: missing body" do
        before(:each) do
          session[:user_id] = @admin.id
          put :update, {content_page: {last_update_user_id: @admin.id}, 
                        translated_content_page: {title: "new title", main_content: "",
                                                 left_content: "left_content", meta_keywords: "meta_keywords", 
                                                 meta_description: "meta_description", active_translation: "1"},
                        content_page_id: content_page.id, id: translated_content_page.id}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
    end
    
    describe "DELETE #destroy" do
     
     let(:peer_log) {SyncPeerLog.first} 
     subject(:translated_content_page) {TranslatedContentPage.gen(content_page: content_page)} 
     
      context "successful deletion" do
        before(:each) do
          session[:user_id] = @admin.id
          delete :destroy, {content_page_id: content_page.id, id: translated_content_page.id}
        end

        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "action of sync peer log is 'create'" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        
        it "type of sync peer log is 'content_page'" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.translated_content_page.id)
        end
        
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "sync peer log 'user_id' equal 'admin_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.id)
        end
        
        it "sync peer log 'object_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "sync peer log 'object_id' equal 'content_page_id'" do
          expect(peer_log.sync_object_id).to eq(content_page.id)
        end
        
        it "creates sync log action parameter for 'language_id'" do
          language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
          expect(language_id_parameter[0][:value]).to eq("#{translated_content_page.language_id}")
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
        
      end
      context "failed deletion" do
        before(:each) do
          delete :destroy, {content_page_id: content_page.id, id: translated_content_page.id}
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        
        after(:each) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        end
      end
    end
    
  end

end
