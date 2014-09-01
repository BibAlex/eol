require "spec_helper"
  
describe SyncPeerLog do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".update_content_upload" do
    let(:user) { User.first }
    subject(:content_upload) { ContentUpload.gen(link_name: "link_name",
                                            description: "description") }
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_upload.update_attributes(origin_id: content_upload.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                        sync_object_type_id: SyncObjectType.content_upload.id,
                                        user_site_object_id: user.origin_id, 
                                        sync_object_id: content_upload.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: content_upload.site_id)
        parameters_values_hash = { link_name: "updated_link_name", description: "updated_description" }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        content_upload.reload
      end
      it "updates 'link_name'" do
        expect(content_upload.link_name).to eq("updated_link_name")
      end
      it "updates 'description'" do
        expect(content_upload.description).to eq("updated_description")
      end
      after(:all) do
        content_upload.destroy if content_upload
      end
    end
  end
end