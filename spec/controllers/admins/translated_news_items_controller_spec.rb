require File.dirname(__FILE__) + '/../../spec_helper'

describe Admins::TranslatedNewsItemsController do

  before(:all) do
    unless @admin = User.find_by_username('admins_controller_specs')
      load_foundation_cache
      @admin = User.gen(:username => 'admins_controllers_specs', :password => "password", :admin => true)
    end
    @non_admin = User.find_by_admin(false)
    @news_item = NewsItem.gen(:page_name => "test_translated_news_item", :active => true, :user => @admin)
  end

  describe 'GET new' do
    before :all do
      @new_translated_news_item_params = { :news_item_id => @news_item.id }
    end
    it 'should only allow access to EOL administrators' do
      get :new
      response.should redirect_to(login_url)
      expect{ get :new, { :id => @news_item.id }, { :user => @non_admin, :user_id => @non_admin.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should instantiate page_title, page_subheader and languages' do
      get :new, @new_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      assigns[:page_title].should == I18n.t(:admin_news_items_page_title)
      assigns[:page_subheader].should == I18n.t(:admin_translated_news_item_new_subheader, :page_name => @news_item.page_name)
      assigns[:languages].should_not be_blank
    end
    it 'should instantiate translated news item' do
      get :new, @new_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      languages = assigns[:languages]
      assigns[:news_item].class.should == NewsItem
      assigns[:translated_news_item].class.should == TranslatedNewsItem
      assigns[:translated_news_item].language_id.should == languages.first.id
      assigns[:translated_news_item].active_translation.should be_true
      response.code.should eq('200')
    end
  end

  describe 'POST create' do
    before :all do
      @new_translated_news_item_params = { :news_item_id => @news_item.id,
        :translated_news_item => { :title => "Test Translated News", :body => "Test Translated News Item Body",
                                   :language_id => Language.english.id, :active_translation => true } }
    end
    before(:each) do
      TranslatedNewsItem.delete_all(:news_item_id => @news_item.id)
    end
    it 'should only allow access to EOL administrators' do
      post :create
      response.should redirect_to(login_url)
      expect{ get :new, { :id => @news_item.id }, { :user => @non_admin, :user_id => @non_admin.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should create a translated news item' do
      post :create, @new_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      assigns[:news_item].class.should == NewsItem
      assigns[:news_item].last_update_user_id == @admin.id
      assigns[:translated_news_item].title.should == "Test Translated News"
      assigns[:translated_news_item].body.should == "Test Translated News Item Body"
      assigns[:translated_news_item].language_id.should == Language.english.id
      assigns[:translated_news_item].active_translation.should be_true
      flash[:notice].should == I18n.t(:admin_translated_news_item_create_successful_notice,
                              :page_name => @news_item.page_name,
                              :anchor => @news_item.page_name.gsub(' ', '_').downcase)
      response.should redirect_to(news_items_path(:anchor => @news_item.page_name.gsub(' ', '_').downcase))
    end
  end

  describe 'GET edit' do
    before :all do
      TranslatedNewsItem.delete_all(:news_item_id => @news_item.id)
      @translated_news_item_to_edit = TranslatedNewsItem.gen(:news_item_id => @news_item.id,
                                                             :title => "Test Translated News",
                                                             :language => Language.english,
                                                             :body => "Test Translated News Item Body",
                                                             :active_translation => true)
      @edit_translated_news_item_params = { :news_item_id => @news_item.id, :id => @translated_news_item_to_edit.id }
    end
    it 'should only allow access to EOL administrators' do
      get :edit
      response.should redirect_to(login_url)
      expect{ get :edit, { :id => @news_item.id }, { :user => @non_admin, :user_id => @non_admin.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should instantiate page_title, page_subheader and page_name' do
      get :edit, @edit_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      assigns[:page_title].should == I18n.t(:admin_news_items_page_title)
      assigns[:page_subheader].should == I18n.t(:admin_translated_news_item_edit_subheader, :page_name => @news_item.page_name,
                                                :language => @translated_news_item_to_edit.language.label.downcase)
    end
    it 'should edit a translated news item' do
      get :edit, @edit_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      assigns[:news_item].class.should == NewsItem
      assigns[:translated_news_item].class.should == TranslatedNewsItem
      assigns[:translated_news_item].id.should == @translated_news_item_to_edit.id
      assigns[:translated_news_item].news_item_id.should == @news_item.id
      assigns[:translated_news_item].title.should == "Test Translated News"
      assigns[:translated_news_item].language.should == Language.english
      assigns[:translated_news_item].body.should == "Test Translated News Item Body"
      assigns[:translated_news_item].active_translation.should be_true
    end
  end

  describe 'PUT update' do
    before :all do
      TranslatedNewsItem.delete_all(:news_item_id => @news_item.id)
      @translated_news_item_to_update = TranslatedNewsItem.gen(:news_item_id => @news_item.id, :title => "Test Translated News",
                                        :language => Language.english, :body => "Test Translated News Item Body", :active_translation => true)
      @update_translated_news_item_params = { :news_item_id => @news_item.id, :id => @translated_news_item_to_update.id,
        :translated_news_item => { :title => "Update Test Translated News", :body => "Update Test Translated News Item Body",
                                   :language_id => Language.english.id, :active_translation => true } }
    end
    it 'should only allow access to EOL administrators' do
      put :update
      response.should redirect_to(login_url)
      expect{ get :new, { :id => @news_item.id }, { :user => @non_admin, :user_id => @non_admin.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should update a translated news item' do
      put :update, @update_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      assigns[:news_item].class.should == NewsItem
      assigns[:translated_news_item].class.should == TranslatedNewsItem
      assigns[:translated_news_item].title.should == "Update Test Translated News"
      assigns[:translated_news_item].body.should == "Update Test Translated News Item Body"
      flash[:notice].should == I18n.t(:admin_translated_news_item_update_successful_notice, :page_name => @news_item.page_name,
                              :language => Language.english.label, :anchor => @news_item.page_name.gsub(' ', '_').downcase)
      response.should redirect_to(news_items_path(:anchor => @news_item.page_name.gsub(' ', '_').downcase))
    end
  end

  describe 'DELETE destroy' do
    before :all do
      TranslatedNewsItem.delete_all(:news_item_id => @news_item.id)
    end
    it 'should only allow access to EOL administrators' do
      delete :destroy
      response.should redirect_to(login_url)
      expect{ get :new, { :id => @news_item.id }, { :user => @non_admin, :user_id => @non_admin.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should delete a translated news item' do
      @translated_news_item_to_delete ||=
        TranslatedNewsItem.gen(:news_item_id => @news_item.id, :title => "Test Translated News",
                               :language => Language.english, :body => "Test Translated News Item Body",
                               :active_translation => true)
      @delete_translated_news_item_params =
        { :news_item_id => @news_item.id, :id => @translated_news_item_to_delete.id }
      delete :destroy, @delete_translated_news_item_params, { :user => @admin, :user_id => @admin.id }
      flash[:notice].should == I18n.t(:admin_translated_news_item_delete_successful_notice, :page_name => @news_item.page_name, :language => Language.english.label)
      response.should redirect_to(news_items_path)
    end
  end

  describe "Synchronization" do
    
    before(:all) do
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
    end
    
    describe "POST #create" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.translated_news_item }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(
        action.id, type.id) }
      let(:news_item) { NewsItem.gen(page_name: "name") }
      before do
        news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        post :create,
          news_item_id: news_item.id, 
          translated_news_item: { "language_id"=>"1", 
                                  "title"=>"un1", 
                                  "body"=>"<p>un1</p>\r\n", 
                                  "active_translation"=>"1" }
      end
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates sync peer log with correct sync_object_action" do
        expect(peer_log.sync_object_action_id).to eq(action.id)
      end
      it "creates sync peer log with correct sync_object_type" do
        expect(peer_log.sync_object_type_id).to eq(type.id)
      end
      it "creates sync peer log with correct user_site_id" do
        expect(peer_log.user_site_id).to eq(current_user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(current_user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(news_item.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(news_item.site_id)
      end
      it "creates sync log action parameter for language_id" do
        language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
        expect(language_id_parameter[0][:value]).to eq("1")
      end
      it "creates sync log action parameter for title" do
        title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
        expect(title_parameter[0][:value]).to eq("un1")
      end
      after(:each) do
        User.find(current_user.id).destroy
        NewsItem.find(news_item.id).destroy
        if TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id)
          TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id).destroy 
        end
      end
    end
    
    describe "PUT #update" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.translated_news_item }
      let(:action) { SyncObjectAction.update }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:news_item) { NewsItem.gen(page_name: "name") }
      before do
        translated_news_item = TranslatedNewsItem.create(title: "title", body: "body",
          language_id: 1, news_item_id: news_item.id)
        news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        put :update,
          news_item_id: news_item.id,
          id: translated_news_item.id,
          translated_news_item: { "language_id"=>"1", 
                                  "title"=>"updated_un1", 
                                  "body"=>"<p>un1</p>\r\n", 
                                  "active_translation"=>"1" }
      end
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates sync peer log with correct sync_object_action" do
        expect(peer_log.sync_object_action_id).to eq(action.id)
      end
      it "creates sync peer log with correct sync_object_type" do
        expect(peer_log.sync_object_type_id).to eq(type.id)
      end
      it "creates sync peer log with correct user_site_id" do
        expect(peer_log.user_site_id).to eq(current_user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(current_user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(news_item.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(news_item.site_id)
      end
      it "creates sync log action parameter for language_id" do
        language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
        expect(language_id_parameter[0][:value]).to eq("1")
      end
      it "creates sync log action parameter for title" do
        title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
        expect(title_parameter[0][:value]).to eq("updated_un1")
      end
      after(:each) do
        User.find(current_user.id).destroy
        NewsItem.find(news_item.id).destroy 
        if TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id)
          TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id).destroy 
        end
      end
    end
    
    describe "DELETE #destroy" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.translated_news_item }
      let(:action) { SyncObjectAction.delete }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:news_item) { NewsItem.gen(page_name: "name") }
      before do
        news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
        translated_news_item = TranslatedNewsItem.create(title: "title", body: "body",
          language_id: 1, news_item_id: news_item.id)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        delete :destroy,
          news_item_id: news_item.id,
          id: translated_news_item.id
      end
      
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates sync peer log with correct sync_object_action" do
        expect(peer_log.sync_object_action_id).to eq(action.id)
      end
      it "creates sync peer log with correct sync_object_type" do
        expect(peer_log.sync_object_type_id).to eq(type.id)
      end
      it "creates sync peer log with correct user_site_id" do
        expect(peer_log.user_site_id).to eq(current_user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(current_user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(news_item.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(news_item.site_id)
      end
      it "creates sync log action parameter for language_id" do
        language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
        expect(language_id_parameter[0][:value]).to eq("1")
      end
      after(:each) do
        User.find(current_user.id).destroy
        NewsItem.find(news_item.id).destroy
      end
    end
  end
end
