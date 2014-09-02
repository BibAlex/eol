require "spec_helper"
  
describe Collection do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".revoke_member" do
    let(:member) { Member.gen }
    let(:user) { User.first }
    let(:community) { Community.first }
    before do
      Member.create(community_id: community.id, manager: 1, user_id: user.id)
      member.update_attributes(origin_id: member.id, site_id: PEER_SITE_ID, community_id: community.id,
        manager: 0)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.revoke.id,
                                      sync_object_type_id: SyncObjectType.member.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: member.origin_id, 
                                      sync_object_site_id: member.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "revokes member" do
      not_manager = Member.find_by_id(member.id)
      expect(not_manager.manager).to be_false
    end
    after(:all) do
      if Member.find_site_specific(member.origin_id, member.site_id)
        Member.find_site_specific(member.origin_id, member.site_id).destroy 
      end
    end
  end
     
  describe ".grant_member" do
    let(:member) { Member.gen }
    let(:user) { User.first }
    let(:community) { Community.first }
    before do
      Member.create(community_id: community.id, manager: 1, user_id: user.id)
      member.update_attributes(origin_id: member.id, site_id: PEER_SITE_ID, community_id: community.id,
        manager: 0)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.grant.id,
                                      sync_object_type_id: SyncObjectType.member.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: member.origin_id, 
                                      sync_object_site_id: member.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "grants member" do
      manager = Member.find_by_id(member.id)
      expect(manager.manager).to be_true
    end
    after(:all) do
      if Member.find_site_specific(member.origin_id, member.site_id)
        Member.find_site_specific(member.origin_id, member.site_id).destroy 
      end
    end
  end
  
  describe ".delete_member" do
    let(:member) { Member.gen }
    let(:user) { User.first }
    let(:community) { Community.first }
    before do
      Member.create(community_id: community.id, manager: 1, user_id: user.id)
      member.update_attributes(origin_id: member.id, site_id: PEER_SITE_ID, community_id: community.id,
        manager: 0)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.member.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: member.origin_id, 
                                      sync_object_site_id: member.site_id)
      create_log_action_parameters({}, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "deletes member" do
      deleted_member = Member.find_by_id(member.id)
      expect(deleted_member).to be_nil
    end
    after(:all) do
      if Member.find_site_specific(member.origin_id, member.site_id)
        Member.find_site_specific(member.origin_id, member.site_id).destroy 
      end
    end
  end
end