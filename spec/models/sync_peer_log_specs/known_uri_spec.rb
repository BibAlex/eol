require "spec_helper"
  
describe KnownUri do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    Visibility.create_enumerated
  end
  
  describe ".delete_known_uri" do
    let(:uri) { KnownUri.gen }
    let(:user) { User.first }
    before do
      uri.update_attributes(origin_id: uri.id, site_id: PEER_SITE_ID)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.known_uri.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: uri.origin_id, 
                                      sync_object_site_id: uri.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "deletes uri" do
      deleted_uri = KnownUri.find_by_id(uri.id)
      expect(deleted_uri).to be_nil
    end
  end
  describe ".hide_known_uri" do
    let(:uri) { KnownUri.gen }
    let(:user) { User.first }
    before do
      uri.update_attributes(origin_id: uri.id, site_id: PEER_SITE_ID)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.hide.id,
                                      sync_object_type_id: SyncObjectType.known_uri.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: uri.origin_id, 
                                      sync_object_site_id: uri.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "hides uri" do
      updated_uri = KnownUri.find_by_id(uri.id)
      expect(updated_uri.visible?).to be_false
    end
    after do
      KnownUri.find_by_id(uri.id).destroy if KnownUri.find_by_id(uri.id)
    end
  end
  
  describe ".show_known_uri" do
    let(:uri) { KnownUri.gen }
    let(:user) { User.first }
    before do
      uri.update_attributes(origin_id: uri.id, site_id: PEER_SITE_ID)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id,
                                      sync_object_type_id: SyncObjectType.known_uri.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: uri.origin_id, 
                                      sync_object_site_id: uri.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "shows hidden uri" do
      updated_uri = KnownUri.find_by_id(uri.id)
      expect(updated_uri.visible?).to be_true
    end
    after do
      KnownUri.find_by_id(uri.id).destroy if KnownUri.find_by_id(uri.id)
    end
  end
end