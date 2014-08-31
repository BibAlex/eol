require "spec_helper"
  
describe Community do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
    
  let(:user) { User.first }
  describe ".create_community" do
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
      #create sync_peer_log
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.community.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, 
                                      sync_object_site_id: 2)
      parameters_values_hash = { community_name: "comm_name", community_description: "community_description",
        collection_origin_id: 12, collection_site_id: 2}
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      #call process entery
      sync_peer_log.process_entry
    end
    it "creates community" do
      comm = Community.find_by_origin_id_and_site_id(80,2)
      expect(comm).not_to be_nil
      expect(comm.name).to eq("comm_name")
      expect(comm.description).to eq("community_description")
    end
    after(:all) do
      Community.find_by_origin_id_and_site_id(80,2).destroy if Community.find_by_origin_id_and_site_id(80,2)
    end
  end
  
  describe ".add_collection_to_community" do
    let(:collection) { Collection.gen }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      community = Community.gen
      community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
      community.add_member(user)
      community.members[0].update_column(:manager, 1)
      collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
      #create sync_peer_log
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id,
                                      sync_object_type_id: SyncObjectType.community.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: community.origin_id, 
                                      sync_object_site_id: community.site_id)
      parameters_values_hash = { collection_origin_id: collection.origin_id, collection_site_id: collection.site_id }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      #call process entery
      sync_peer_log.process_entry
    end
    it "adds collection to community" do
      expect(collection.communities.count).to eq(1)
    end
    after(:all) do
      Community.last.destroy if Community.last
      col = Collection.find_by_origin_id_and_site_id(collection.id, PEER_SITE_ID)
      col.destroy if col
    end
  end
  
  describe ".update_community" do
    let(:community) { Community.gen }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
      #create sync_peer_log
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.community.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: community.origin_id, 
                                      sync_object_site_id: community.site_id)
      parameters_values_hash = { community_name: "new_name", community_description: "new_description",
        name_change: 1, description_change: 1 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      #call process entery
      sync_peer_log.process_entry
    end
    it "updates community" do
      new_community = Community.find(community.id)
      expect(new_community).not_to be_nil
      expect(new_community.name).to eq("new_name")
      expect(new_community.description).to eq("new_description")
    end
  end
  
  describe ".delete_community" do
    let(:community) { Community.gen }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
      community.add_member(user)
      #create sync_peer_log
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.community.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: community.origin_id, 
                                      sync_object_site_id: community.site_id)
      #call process entery
      sync_peer_log.process_entry                               
    end
    it "deletes community" do
      unpublished_community = Community.find(community.id)
      expect(unpublished_community.published).to be_false
    end
    after(:all) do
      Community.find(community.id).destroy if Community.find(community.id)
    end
  end
  
  describe ".join_community" do
    let(:community) { Community.gen }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID)
      #create sync_peer_log
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.join.id,
                                      sync_object_type_id: SyncObjectType.community.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: community.origin_id, 
                                      sync_object_site_id: community.site_id)
      @prev_members_count = community.members.count
      #call process entery
      sync_peer_log.process_entry
    end
    it "adds member to community" do
      comm = Community.find(community.id)
      comm.members.count.should == @prev_members_count + 1
    end
    after(:all) do
      Community.find(community.id).destroy if Community.find(community.id)
    end
  end
  
  describe ".leave_community" do
    let(:community) { Community.gen }
    let(:prev_members_count) { community.members.count }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID)
      community.add_member(user)
      #create sync_peer_log
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.leave.id,
                                      sync_object_type_id: SyncObjectType.community.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: community.origin_id, 
                                      sync_object_site_id: community.site_id)
      @prev_members_count = community.members.count
      #call process entery
      sync_peer_log.process_entry
    end
    it "adds member to community" do
      comm = Community.find(community.id)
      comm.members.count.should == @prev_members_count - 1
    end
    after(:all) do
      Community.find(community.id).destroy if Community.find(community.id)
    end
  end
end