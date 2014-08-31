require "spec_helper"
  
describe Hierarchy do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".update_Hierarchy" do
    let(:hierarchy) { Hierarchy.find(Resource.first.hierarchy_id) }
    let(:user) { User.find(hierarchy.resource.content_partner_id) }
    before do
      hierarchy.update_attributes(origin_id: hierarchy.id, site_id: PEER_SITE_ID)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.hierarchy.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: hierarchy.origin_id, 
                                      sync_object_site_id: hierarchy.site_id)
      parameters_values_hash = { label: "updated_label", 
                                 descriptive_label: "updated_descriptive_label", 
                                 description: "updated_description", 
                                 browsable: "0", 
                                 request_publish: "1" }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "updates hierarchy" do
      updated_hierarchy = Hierarchy.find(hierarchy.id)
      expect(updated_hierarchy.label).to eq("updated_label")
      expect(updated_hierarchy.descriptive_label).to eq("updated_descriptive_label")
      expect(updated_hierarchy.description).to eq("updated_description")
      expect(updated_hierarchy.browsable).to eq(0)
      expect(updated_hierarchy.request_publish).to eq(true)
    end
  end
  
  describe ".request_publish_Hierarchy" do
    let(:hierarchy) { Hierarchy.find(Resource.first.hierarchy_id) }
    let(:user) { User.find(hierarchy.resource.content_partner_id) }
    before do
      hierarchy.update_attributes(origin_id: hierarchy.id, site_id: PEER_SITE_ID)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.request_publish.id,
                                      sync_object_type_id: SyncObjectType.hierarchy.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: hierarchy.origin_id, 
                                      sync_object_site_id: hierarchy.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "requests to publish hierarchy" do
      updated_hierarchy = Hierarchy.find(hierarchy.id)
      expect(updated_hierarchy.request_publish).to eq(true)
    end
  end
end