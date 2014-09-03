require "spec_helper"
describe Users::DataDownloadsController do
  describe "synchronization" do
    before(:all) do
      truncate_all_tables
      load_foundation_cache
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
    end
      
    describe "DELETE #destroy" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:data_search_file) { DataSearchFile.gen(user: user, known_uri: known_uri) }
      let(:user) { User.first }
      let(:known_uri) { KnownUri.gen }
      
      context "when successful deletion" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          known_uri.update_attributes(origin_id: known_uri.id, site_id: PEER_SITE_ID)
          data_search_file.update_attributes(origin_id: data_search_file.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          delete :destroy, { user_id: user.id, id: data_search_file.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.data_search_file.id)
        end
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(data_search_file.origin_id)
        end
        after do
          data_search_file.destroy if data_search_file
          known_uri.destroy if known_uri
        end
      end
      
      context "when deletion fails because the user should login" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          known_uri.update_attributes(origin_id: known_uri.id, site_id: PEER_SITE_ID)
          data_search_file.update_attributes(origin_id: data_search_file.id, site_id: PEER_SITE_ID)
          expect { delete :destroy, { user_id: user.id, id: data_search_file.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          data_search_file.destroy if data_search_file
          known_uri.destroy if known_uri
        end
      end
    end
  end
end
