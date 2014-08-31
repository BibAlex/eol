require "spec_helper"
  
describe ForumPost do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_post" do
    let(:topic) { ForumTopic.gen }
    let(:user) { User.first }
    subject(:forum_post) { ForumPost.find_site_specific(100, PEER_SITE_ID)}
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                        sync_object_type_id: SyncObjectType.post.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 100,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { subject: "post subject", text: "post body",
                                   topic_origin_id: topic.origin_id,
                                   topic_site_id: topic.site_id,
                                   edit_count: 1 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new post" do
        expect(forum_post).not_to be_nil          
      end
      it "has the correct 'subject'" do
        expect(forum_post.subject).to eq("post subject")
      end
      it "has the correct 'text'" do
        expect(forum_post.text).to eq("post body")
      end
      it "has the correct 'user_id'" do
        expect(forum_post.user_id).to eq(user.id)
      end
      it "has the correct 'forum_topic_id'" do
        expect(forum_post.forum_topic_id).to eq(topic.id)
      end
      after(:all) do
        forum_post.destroy if forum_post
        topic.destroy if topic
      end
    end
  end
  
  describe ".create_post 'reply'" do
    let(:topic) { ForumTopic.gen }
    let(:user) { User.first }
    subject(:forum_post) { ForumPost.find_site_specific(100, PEER_SITE_ID)}
    let(:parent_post) { ForumPost.gen(user_id: user.id, forum_topic_id: topic.id) }
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
        parent_post.update_attributes(origin_id: parent_post.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                        sync_object_type_id: SyncObjectType.post.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 100,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { subject: "post subject", text: "post body",
                                   topic_origin_id: topic.origin_id,
                                   topic_site_id: topic.site_id,
                                   parent_post_origin_id: parent_post.origin_id,
                                   parent_post_site_id: parent_post.site_id,
                                   edit_count: 1 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new post" do
        expect(forum_post).not_to be_nil          
      end
      it "has the correct 'subject'" do
        expect(forum_post.subject).to eq("post subject")
      end
      it "has the correct 'text'" do
        expect(forum_post.text).to eq("post body")
      end
      it "has the correct 'user_id'" do
        expect(forum_post.user_id).to eq(user.id)
      end
      it "has the correct 'forum_topic_id'" do
        expect(forum_post.forum_topic_id).to eq(topic.id)
      end
      it "has the correct 'reply_to_post_id'" do
        expect(forum_post.reply_to_post_id).to eq(parent_post.id)
      end
      after(:all) do
        forum_post.destroy if forum_post
        parent_post.destroy if parent_post
        topic.destroy if topic
      end
    end
  end
  
  describe ".update_post" do
    let(:topic) { ForumTopic.gen }
    let(:user) { User.first }
    subject(:forum_post) { ForumPost.gen(user_id: user.id, forum_topic_id: topic.id,
                                         subject: "post subject", text: "post body",
                                         updated_at: Time.now)}
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
        forum_post.update_attributes(origin_id: forum_post.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                        sync_object_type_id: SyncObjectType.post.id,
                                        user_site_object_id: user.origin_id, sync_object_id: forum_post.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { subject: "updated post subject", text: "updated post body",
                                   edit_count: 1, updated_at: forum_post.updated_at + 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        forum_post.reload
      end
      it "updates 'subject' of post" do
        expect(forum_post.subject).to eq("updated post subject")
      end
      it "updates 'text' of post" do
        expect(forum_post.text).to eq("updated post body")
      end
      after(:all) do
        forum_post.destroy if forum_post
        topic.destroy if topic
      end
    end
    
    # handle synchronization conflict: last update wins
    context "when update fails because there is a newer update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
        forum_post.update_attributes(origin_id: forum_post.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                        sync_object_type_id: SyncObjectType.post.id,
                                        user_site_object_id: user.origin_id, sync_object_id: forum_post.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { subject: "updated post subject", text: "updated post body",
                                   edit_count: 1, updated_at: forum_post.updated_at - 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        forum_post.reload
      end
      it "doesn't update 'subject' of post" do
        expect(forum_post.subject).to eq("post subject")
      end
      it "doesn't update 'text' of post" do
        expect(forum_post.text).to eq("post body")
      end
      after(:all) do
        forum_post.destroy if forum_post
        topic.destroy if topic
      end
    end
  end
  
  describe ".delete_post" do
    let(:topic) { ForumTopic.gen }
    let(:user) { User.first }
    subject(:forum_post) { ForumPost.gen(user_id: user.id, forum_topic_id: topic.id,
                                         subject: "post subject", text: "post body")}
    
    context "when successful deletion" do
      before(:all) do
        @deleted_at = Time.now
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
        forum_post.update_attributes(origin_id: forum_post.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, 
                                        sync_object_type_id: SyncObjectType.post.id,
                                        user_site_object_id: user.origin_id, sync_object_id: forum_post.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { edit_count: 1, post_deleted_at: @deleted_at }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        forum_post.reload
      end
      it "deletes the post" do
        expect(forum_post.deleted_at.utc.to_s).to eq(@deleted_at.utc.to_s)
      end
      it "has correct 'deleted_by_user_id'" do
        expect(forum_post.deleted_by_user_id).to eq(user.id)
      end
      after(:all) do
        forum_post.destroy if forum_post
        topic.destroy if topic
      end
    end
  end
end