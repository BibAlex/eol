require "spec_helper"
describe MembersController do
  
 
  
  describe "synchronization" do
    before(:all) do
      truncate_all_tables
      load_foundation_cache
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
    end
    
    describe "DELETE #destroy" do
      let(:type) { SyncObjectType.member }
      let(:action) { SyncObjectAction.delete }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:current_user) { User.first }
      let(:member) { Member.gen }
      let(:community) { Community.first }
      before do
        Member.create(community_id: community.id, manager: 1, user_id: current_user.id)
        member.update_attributes(origin_id: member.id, site_id: PEER_SITE_ID, community_id: community.id,
          manager: 0)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        delete :destroy,
          id: member.id,
          community_id: community.id
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
        expect(peer_log.sync_object_id).to eq(member.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(member.site_id)
      end
      after do
        if Member.find_site_specific(member.origin_id, member.site_id)
          Member.find_site_specific(member.origin_id, member.site_id).destroy 
        end
      end
    end
    
    describe "GET #grant_manager" do
      let(:type) { SyncObjectType.member }
      let(:action) { SyncObjectAction.grant }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:current_user) { User.first }
      let(:member) { Member.gen }
      let(:community) { Community.first }
      before do
        Member.create(community_id: community.id, manager: 1, user_id: current_user.id)
        member.update_attributes(origin_id: member.id, site_id: PEER_SITE_ID, community_id: community.id,
          manager: 0)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        get :grant_manager,
          id: member.id,
          community_id: community.id
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
        expect(peer_log.sync_object_id).to eq(member.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(member.site_id)
      end
      after do
        if Member.find_site_specific(member.origin_id, member.site_id)
          Member.find_site_specific(member.origin_id, member.site_id).destroy 
        end
      end
    end
    
    describe "GET #revoke_manager" do
      let(:type) { SyncObjectType.member }
      let(:action) { SyncObjectAction.revoke }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:current_user) { User.first }
      let(:member) { Member.gen }
      let(:community) { Community.first }
      before do
        Member.create(community_id: community.id, manager: 1, user_id: current_user.id)
        member.update_attributes(origin_id: member.id, site_id: PEER_SITE_ID, community_id: community.id,
          manager: 0)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        get :revoke_manager,
          id: member.id,
          community_id: community.id
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
        expect(peer_log.sync_object_id).to eq(member.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(member.site_id)
      end
      after do
        if Member.find_site_specific(member.origin_id, member.site_id)
          Member.find_site_specific(member.origin_id, member.site_id).destroy 
        end
      end
    end
    
  end
end