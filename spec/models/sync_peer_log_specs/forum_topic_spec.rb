require "spec_helper"
  
describe ForumTopic do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_topic" do
    let(:forum) { Forum.gen }
    before do
      forum.update_attributes(origin_id: forum.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.topic.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, #create a new one with this origin_id 
                                      sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = { forum_origin_id: forum.origin_id,
                                 forum_site_id: forum.site_id,
                                 first_post_origin_id: 90,
                                 first_post_site_id: PEER_SITE_ID,
                                 subject: "topic create subject",
                                 text:  "topic create text" }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new topic" do
      topic = ForumTopic.find_by_forum_id_and_origin_id(forum.id, 80)
      expect(topic).not_to be_nil
      expect(topic.title).to eq("topic create subject")
      
      expect(topic.first_post.text).to eq("topic create text")
      expect(topic.first_post.origin_id).to eq(90)
    end
    after do
      if ForumTopic.find_by_forum_id_and_origin_id(forum.id, 80)
        ForumTopic.find_by_forum_id_and_origin_id(forum.id, 80).destroy
      end
      Forum.find(forum.id).destroy if Forum.find(forum.id)
    end
  end
  describe ".delete_topic" do
    let(:topic) { ForumTopic.gen }
    before do
      @id = topic.id
      topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.topic.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: topic.origin_id,  
                                      sync_object_site_id: topic.site_id)
      parameters_values_hash = {}
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "deletes topic" do
      topic = ForumTopic.find(@id)
      expect(topic.deleted_at).not_to be_nil
      expect(topic.deleted_by_user_id).to eq(User.first.id)
    end
  end
end