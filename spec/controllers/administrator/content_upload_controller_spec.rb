require "spec_helper"
describe Administrator::ContentUploadController do
  describe "synchronization" do
    before(:all) do
      truncate_all_tables
      load_foundation_cache
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
    end
      
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:content_upload) { ContentUpload.gen }
      let(:admin) { User.first }
      
      context "when successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          content_upload.update_attributes(origin_id: content_upload.id, site_id: PEER_SITE_ID)
          admin.grant_admin
          session[:user_id] = admin.id
          put :update, content_upload: { description: "fil_description", link_name: "file_url" },
                       id: content_upload.id
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.content_upload.id)
        end
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(admin.origin_id)
        end
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(content_upload.origin_id)
        end
        it "creates sync log action parameter for 'description'" do
          description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
          expect(description_parameter[0][:value]).to eq("fil_description")
        end
        it "creates sync log action parameter for 'link_name'" do
          link_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "link_name")
          expect(link_name_parameter[0][:value]).to eq("file_url")
        end
        after do
          content_upload.destroy if content_upload
        end
      end
    end
  end
end
