require "spec_helper"
  
describe Forum do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_forum" do
    let(:forum_category) { ForumCategory.gen }
    let(:user) { User.first }
    subject(:forum) { Forum.find_site_specific(100, PEER_SITE_ID)}
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                        sync_object_type_id: SyncObjectType.forum.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 100,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { name: "new forum", description: "forum description",
                                   forum_category_origin_id: forum_category.origin_id,
                                   forum_category_site_id: forum_category.site_id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new forum" do
        expect(forum).not_to be_nil          
      end
      it "has the correct 'name'" do
        expect(forum.name).to eq("new forum")
      end
      it "has the correct 'description'" do
        expect(forum.description).to eq("forum description")
      end
      it "has the correct 'user_id'" do
        expect(forum.user_id).to eq(user.id)
      end
      it "has the correct 'forum_category_id'" do
        expect(forum.forum_category_id).to eq(forum_category.id)
      end
      after(:all) do
        forum.destroy if forum
        forum_category.destroy if forum_category
      end
    end
  end
  
  describe ".update_forum" do
    let(:forum_category) { ForumCategory.gen(user_id: user.id) }
    let(:user) { User.first }
    subject(:forum) { Forum.gen(user_id: user.id)}
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
        forum.update_attributes(origin_id: forum.id, site_id: PEER_SITE_ID,
                                updated_at: Time.now)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                        sync_object_type_id: SyncObjectType.forum.id,
                                        user_site_object_id: user.origin_id, sync_object_id: forum.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { name: "updated forum", description: "updated forum description",
                                   forum_category_origin_id: forum_category.origin_id,
                                   forum_category_site_id: forum_category.site_id,
                                   updated_at: forum.updated_at + 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        forum.reload
      end
      
      it "updates 'name'" do
        expect(forum.name).to eq("updated forum")
      end
      it "updates 'description'" do
        expect(forum.description).to eq("updated forum description")
      end
      it "has the correct 'user_id'" do
        expect(forum.user_id).to eq(user.id)
      end
      it "has the correct 'forum_category_id'" do
        expect(forum.forum_category_id).to eq(forum_category.id)
      end
      after(:all) do
        forum.destroy if forum
        forum_category.destroy if forum_category
      end
    end
  end
  
  describe ".delete_forum" do
    let(:forum_category) { ForumCategory.gen(user_id: user.id) }
    let(:user) { User.first }
    subject(:forum) { Forum.gen(user_id: user.id)}
    
    context "when successful deletion" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
        forum.update_attributes(origin_id: forum.id, site_id: PEER_SITE_ID,
                                updated_at: Time.now)
        @forum_id = forum.id
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, 
                                        sync_object_type_id: SyncObjectType.forum.id,
                                        user_site_object_id: user.origin_id, sync_object_id: forum.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        sync_peer_log.process_entry
      end
      it "deletes forum'" do
        expect(Forum.find_site_specific(@forum_id, PEER_SITE_ID)).to be_nil
      end
      after(:all) do
        forum.destroy if forum
        forum_category.destroy if forum_category
      end
    end
  end
end