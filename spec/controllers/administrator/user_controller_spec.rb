require "spec_helper"

describe Administrator::UserController do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe "GET #hide" do
    let(:user) { User.first }
    let(:admin) { User.last }
    let(:type) {SyncObjectType.user}
    let(:action) {SyncObjectAction.hide}
    let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
    before do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
      admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
      admin.grant_admin 
      session[:user_id] = admin.id
      request.env["HTTP_REFERER"] = "http://localhost:3001/administrator/user"
      get :hide, { id: user.id }
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
      expect(peer_log.user_site_id).to eq(admin.site_id)
    end
    it "creates sync peer log with correct user_site_object_id" do
      expect(peer_log.user_site_object_id).to eq(admin.origin_id)
    end
    it "creates sync peer log with correct sync_object_id" do
      expect(peer_log.sync_object_id).to eq(user.origin_id)
    end
    it "creates sync peer log with correct sync_object_site_id" do
      expect(peer_log.sync_object_site_id).to eq(user.site_id)
    end
  end
  
  describe "GET #show" do
    let(:user) { User.first }
    let(:admin) { User.last }
    let(:type) {SyncObjectType.user}
    let(:action) {SyncObjectAction.show}
    let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id)}
    before do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
      admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
      admin.grant_admin 
      session[:user_id] = admin.id
      request.env["HTTP_REFERER"] = "http://localhost:3001/administrator/user"
      get :unhide, { id: user.id }
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
      expect(peer_log.user_site_id).to eq(admin.site_id)
    end
    it "creates sync peer log with correct user_site_object_id" do
      expect(peer_log.user_site_object_id).to eq(admin.origin_id)
    end
    it "creates sync peer log with correct sync_object_id" do
      expect(peer_log.sync_object_id).to eq(user.origin_id)
    end
    it "creates sync peer log with correct sync_object_site_id" do
      expect(peer_log.sync_object_site_id).to eq(user.site_id)
    end
  end
  describe "PUT #update" do
    let(:peer_log) { SyncPeerLog.first }
    subject(:user) { User.gen(username: 'users_controller_spec', 
                             requested_curator_level_id: 2, credentials: "Faculty, staff, or graduate student status in a relevant university or college department",
                             curator_scope: "Rodents of Borneo") }
    let(:admin) { User.gen(username: "admin", password: "admin") }
    
    context "successful update" do
      before do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters","users"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
        session[:user_id] = admin.id
        admin.grant_admin 
        put :update, { id: user.id, user: { id: user.id, username: 'newusername', curator_level_id: 2 } }
      end
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "has correct action" do
        expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update_by_admin.id)
      end
      it "has correct type" do
        expect(peer_log.sync_object_type_id).to eq(SyncObjectType.user.id)
      end
      it "has correct 'user_site_id'" do
        expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
      end
      it "has correct 'user_id'" do
        expect(peer_log.user_site_object_id).to eq(admin.id)
      end
      it "has correct 'object_site_id'" do
        expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
      end
      it "has correct 'object_id' equal 'user_id'" do
        expect(peer_log.sync_object_id).to eq(user.id)
      end
      it "creates sync log action parameter for 'user_name'" do
        username_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "username")
        expect(username_parameter[0][:value]).to eq("newusername")
      end
      it "creates sync log action parameter for 'curator_level_id'" do
        curator_level_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "curator_level_id")
        expect(curator_level_parameter[0][:value]).to eq("2")
      end
      it "creates sync log action parameter for 'curator_approved'" do
        curator_approved_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "curator_approved")
        expect(curator_approved_parameter[0][:value]).to eq("1")
      end
    end
  end
end