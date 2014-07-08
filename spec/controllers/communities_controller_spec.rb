 require "spec_helper"

def log_in_for_controller(controller, user)
  session[:user_id] = user.id
  controller.set_current_user = user
end

describe CommunitiesController do

  before :all do
    truncate_all_tables
    load_scenario_with_caching(:communities)
    SyncObjectAction.create_enumerated
    SyncObjectType.create_enumerated
    SpecialCollection.create(:name => "watch")
          
  end
  describe "syncronization" do
    before do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
    end
    describe "#create_community" do
      let(:user) {User.first}
      let(:collection) {Collection.first}
      let(:action) {SyncObjectAction.create}
      let(:type) {SyncObjectType.community }
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
      let(:created_community) {Community.last}
      before(:all) do
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
      end
      before do
        allow(controller).to receive(:current_user) { user }
             log_in_for_controller(controller, user)
             
        post :create, {:community => {:name => "created_name", :description => "created_desc"},
                       :collection_id => collection.id}
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
        expect(peer_log.user_site_id).to eq(user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(created_community.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(created_community.site_id)
      end
      it "creates sync log action parameter for community_name" do
        community_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "community_name")
        expect(community_name_parameter[0][:value]).to eq("created_name")
      end
      it "creates sync log action parameter for community_description" do
        community_description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "community_description")
        expect(community_description_parameter[0][:value]).to eq("created_desc")
      end
      it "creates sync log action parameter for collection_origin_id" do
        collection_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_origin_id")
        expect(collection_origin_id_parameter[0][:value]).to eq("#{collection.origin_id}")
      end
      it "creates sync log action parameter for collection_site_id" do
        collection_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_site_id")
        expect(collection_site_id_parameter[0][:value]).to eq("#{collection.site_id}")
      end
      after(:all) do
        Community.find(created_community.id).destroy
      end
    end
    describe "#add_collection" do
      let(:user) {User.first}
      let(:collection) {Collection.first}
      let(:action) {SyncObjectAction.add}
      let(:type) {SyncObjectType.community }
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
      let(:community) {Community.gen}
      before(:all) do
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID,
                                    name: "name", description: "desc")
        community.add_member(user)
        community.members[0].update_column(:manager, 1)                                                                        
      end
      before do
        allow(controller).to receive(:current_user) { user }
        log_in_for_controller(controller, user)
        post :make_editors, {collection_id: collection.id, community_id: [community.id] }
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
        expect(peer_log.user_site_id).to eq(user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(community.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(community.site_id)
      end
      it "creates sync log action parameter for collection_origin_id" do
        collection_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_origin_id")
        expect(collection_origin_id_parameter[0][:value]).to eq("#{collection.origin_id}")
      end
      it "creates sync log action parameter for collection_site_id" do
        collection_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_site_id")
        expect(collection_site_id_parameter[0][:value]).to eq("#{collection.site_id}")
      end
      after(:all) do
        Community.find(community.id).destroy
      end
    end
    describe "#update_community" do
      let(:user) {User.first}
      let(:collection) {Collection.first}
      let(:action) {SyncObjectAction.update}
      let(:type) {SyncObjectType.community }
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
      let(:community) {Community.gen}
      before(:all) do
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID,
                                    name: "name", description: "desc")
        community.add_member(user)
        community.members[0].update_column(:manager, 1)                                                                        
      end
      before do
        allow(controller).to receive(:current_user) { user }
        log_in_for_controller(controller, user)
        put :update, {:community_id => community.id, :id => community.id,
                      :community => {:id => community.id,
                                     :name => "new_name",
                                     :description => "new_desc"},
                      :collection_id => collection.id}
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
        expect(peer_log.user_site_id).to eq(user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(community.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(community.site_id)
      end
      it "creates sync log action parameter for community_name" do
        community_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "community_name")
        expect(community_name_parameter[0][:value]).to eq("new_name")
      end
      it "creates sync log action parameter for community_description" do
        community_description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "community_description")
        expect(community_description_parameter[0][:value]).to eq("new_desc")
      end
      after(:all) do
        Community.find(community.id).destroy
      end
    end
    describe "#delete_community" do
      let(:user) {User.first}
      let(:collection) {Collection.first}
      let(:action) {SyncObjectAction.delete}
      let(:type) {SyncObjectType.community }
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
      let(:community) {Community.gen}
      before do
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID,
                                    name: "name", description: "desc", published: 1)
        community.add_member(user)
        community.members[0].update_column(:manager, 1)   
        allow(controller).to receive(:current_user) { user }
        log_in_for_controller(controller, user)
        get :delete, {:community_id => community.id,
                      :id => community.id,
                      :community => {:id => community.id,
                                     :name => "name",
                                     :description => "desc"},
                      :collection_id => collection.id}
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
        expect(peer_log.user_site_id).to eq(user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(community.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(community.site_id)
      end
      after do
        Community.find(community.id).destroy
      end
    end
    
    describe "#join_community" do
      let(:user) {User.first}
      let(:collection) {Collection.first}
      let(:action) {SyncObjectAction.join}
      let(:type) {SyncObjectType.community }
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
      let(:community) {Community.gen}
      
      before(:all) do
        CuratorCommunity.build
      end
      before do
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID,
                                    name: "name", description: "desc", published: 1)
        allow(controller).to receive(:current_user) { user }
        log_in_for_controller(controller, user)
        get :join, {:community_id => community.id, :id => community.id,
                    :community => {:id => community.id,
                                   :name => "new_name",
                                   :description => "new_desc"},
                    :collection_id => collection.id}
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
        expect(peer_log.user_site_id).to eq(user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(community.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(community.site_id)
      end
      after do
        Community.find(community.id).destroy
      end
    end
    
    describe "#leave_community" do
      let(:user) {User.first}
      let(:collection) {Collection.first}
      let(:action) {SyncObjectAction.leave}
      let(:type) {SyncObjectType.community }
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
      let(:community) {Community.gen}
      
      before(:all) do
        CuratorCommunity.build
      end
      before do
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID,
                                    name: "name", description: "desc", published: 1)
        community.add_member(user)
        allow(controller).to receive(:current_user) { user }
        log_in_for_controller(controller, user)
        get :leave, {:community_id => community.id, :id => community.id,
                     :community => {:id => community.id,
                                    :name => "new_name",
                                    :description => "new_desc"},
                     :collection_id => collection.id}
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
        expect(peer_log.user_site_id).to eq(user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(community.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(community.site_id)
      end
      after do
        Community.find(community.id).destroy
      end
    end
  end
end