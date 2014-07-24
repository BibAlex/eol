require "spec_helper"

def log_in_for_controller(controller, user)
  session[:user_id] = user.id
  controller.set_current_user = user
end

describe Administrator::GlossaryController do
  
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectAction.create_enumerated
    SyncObjectType.create_enumerated
  end
  
  describe "Synchronization of creating glossary term" do
    let(:user) { User.first }
    let(:action) { SyncObjectAction.create }
    let(:type) { SyncObjectType.glossary_term }
    let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
    let(:created_glossary_term) { GlossaryTerm.last}
    before(:all) do
      user.update_attributes(site_id: PEER_SITE_ID, admin: 1)
    end
    before do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      post :create, { glossary_term: { term: "create_term", definition: "create_def" } }
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
      expect(peer_log.sync_object_id).to eq(created_glossary_term.origin_id)
    end
    it "creates sync peer log with correct sync_object_site_id" do
      expect(peer_log.sync_object_site_id).to eq(created_glossary_term.site_id)
    end
    after(:each) do
      GlossaryTerm.last.destroy
    end
  end
end