require File.dirname(__FILE__) + '/../../spec_helper'

describe Admins::NewsItemsController do
  describe "Synchronization" do
    before(:all) do
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
    end
    
    describe "POST #create" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.news_item }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      before do
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        post :create,
          "news_item"=>{ "page_name"=>"un1", 
                         "display_date(3i)"=>"5",
                         "display_date(2i)"=>"8",
                         "display_date(1i)"=>"2014",
                         "display_date(4i)"=>"12",
                         "display_date(5i)"=>"42",
                         "activated_on(3i)"=>"5",
                         "activated_on(2i)"=>"8",
                         "activated_on(1i)"=>"2014",
                         "activated_on(4i)"=>"12",
                         "activated_on(5i)"=>"42", 
                         "active"=>"1" }, 
          "translated_news_item"=>{ "language_id"=>"1", 
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
        expect(peer_log.sync_object_id).to eq(NewsItem.last.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(NewsItem.last.site_id)
      end
      it "creates sync log action parameter for page_name" do
        page_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "page_name")
        expect(page_name_parameter[0][:value]).to eq("un1")
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
        User.last.destroy
        NewsItem.last.destroy if NewsItem.last 
      end
    end
    
    describe "PUT #update" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.news_item }
      let(:action) { SyncObjectAction.update }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:news_item) { NewsItem.gen(page_name: "old_name") }
      before do
        news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        put :update,
          id: news_item.id,
          "news_item"=>{ "page_name"=>"un1", 
                         "display_date(3i)"=>"5",
                         "display_date(2i)"=>"8",
                         "display_date(1i)"=>"2014",
                         "display_date(4i)"=>"12",
                         "display_date(5i)"=>"42",
                         "activated_on(3i)"=>"5",
                         "activated_on(2i)"=>"8",
                         "activated_on(1i)"=>"2014",
                         "activated_on(4i)"=>"12",
                         "activated_on(5i)"=>"42", 
                         "active"=>"1" }
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
      it "creates sync log action parameter for page_name" do
        page_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "page_name")
        expect(page_name_parameter[0][:value]).to eq("un1")
      end
      after(:each) do
        User.last.destroy
        NewsItem.find(news_item.id).destroy if NewsItem.find(news_item.id) 
      end
    end
    
    describe "DELETE #destroy" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.news_item }
      let(:action) { SyncObjectAction.delete }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:news_item) { NewsItem.gen(page_name: "name") }
      before do
        news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        delete :destroy,
          id: news_item.id
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
      after(:each) do
        User.last.destroy
      end
    end
  end
 
end
