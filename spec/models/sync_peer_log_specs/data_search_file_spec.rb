require "spec_helper"
  
describe SyncPeerLog do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".delete_data_search_file" do
    context "when successful deletion" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user = User.first
        known_uri = KnownUri.gen
        data_search_file = DataSearchFile.gen(user: user, known_uri: known_uri)
        @known_uri_id = known_uri.id
        @data_search_file_id = data_search_file.id
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        known_uri.update_attributes(origin_id: known_uri.id, site_id: PEER_SITE_ID)
        data_search_file.update_attributes(origin_id: data_search_file.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, 
                                        sync_object_type_id: SyncObjectType.data_search_file.id,
                                        user_site_object_id: user.origin_id, 
                                        sync_object_id: data_search_file.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: data_search_file.site_id)
        sync_peer_log.process_entry
      end
      it "deletes data search file" do
        expect(DataSearchFile.find_site_specific(@data_search_file_id, PEER_SITE_ID)).to be_nil
      end
      after(:all) do
        KnownUri.find(@known_uri_id).destroy if KnownUri.find(@known_uri_id)
        DataSearchFile.find(@data_search_file_id).destroy if DataSearchFile.find(@data_search_file_id)
      end
    end
  end
end