require File.dirname(__FILE__) + '/../../../spec_helper'

describe ContentPartners::Resources::HierarchiesController do
  before(:all) do
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  describe "Synchronization" do
    describe "PUT #update" do
      let(:type) { SyncObjectType.hierarchy }
      let(:action) { SyncObjectAction.update }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:hierarchy) { Hierarchy.find(Resource.first.hierarchy_id) }
      let(:current_user) { User.find(hierarchy.resource.content_partner_id) }
      before do
        hierarchy.update_attributes(origin_id: hierarchy.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        put :update,
          hierarchy: {
            label: "updated_label", 
            descriptive_label: "updated_descriptive_label", 
            description: "updated_description", 
            browsable: "0", 
            request_publish: "1" },
          content_partner_id: current_user.id, 
          resource_id: hierarchy.resource.id, 
          id: hierarchy.id
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
        expect(peer_log.sync_object_id).to eq(hierarchy.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(hierarchy.site_id)
      end
      it "creates sync log action parameter for label" do
        label_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "label")
        expect(label_parameter[0][:value]).to eq("updated_label")
      end
      it "creates sync log action parameter for descriptive_label" do
        descriptive_label_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "descriptive_label")
        expect(descriptive_label_parameter[0][:value]).to eq("updated_descriptive_label")
      end
      it "creates sync log action parameter for description" do
        description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
        expect(description_parameter[0][:value]).to eq("updated_description")
      end
      it "creates sync log action parameter for browsable" do
        browsable_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "browsable")
        expect(browsable_parameter[0][:value]).to eq("0")
      end
      it "creates sync log action parameter for request_publish" do
        request_publish_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "request_publish")
        expect(request_publish_parameter[0][:value]).to eq("1")
      end
    end
    
    describe "POST #request_publish" do
      let(:type) { SyncObjectType.hierarchy }
      let(:action) { SyncObjectAction.request_publish }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:hierarchy) { Hierarchy.find(Resource.first.hierarchy_id) }
      let(:current_user) { User.find(hierarchy.resource.content_partner_id) }
      before do
        hierarchy.update_attributes(origin_id: hierarchy.id, site_id: PEER_SITE_ID, 
          browsable: false, request_publish: false)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1,
          email: "test@example.com")
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        expect{ post :request_publish,
          content_partner_id: current_user.id, 
          resource_id: hierarchy.resource.id, 
          id: hierarchy.id }.to raise_error
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
        expect(peer_log.sync_object_id).to eq(hierarchy.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(hierarchy.site_id)
      end
    end
  end
end