require "spec_helper"
  
describe Comment do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    Visibility.create_enumerated
  end
    
  describe ".create_comment" do
    let(:user) { User.first } 
    let(:comment_parent) { Collection.first }
    subject(:comment) { Comment.find_by_origin_id_and_site_id(20, PEER_SITE_ID) }
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 20, user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { parent_type: "Collection", comment_parent_origin_id: comment_parent.origin_id,
          comment_parent_site_id: comment_parent.site_id, body: "comment" }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new comment" do
        expect(comment).not_to be_nil          
      end
      it "has the correct 'body'" do
        expect(comment.body).to eq("comment")
      end
      it "has the correct 'user_id'" do
        expect(comment.user_id).to eq(user.id)
      end
      it "has the correct 'parent_id'" do
        expect(comment.parent_id).to eq(comment_parent.id)
      end
      it "has the correct 'parent_type'" do
        expect( comment.parent_type).to eq("Collection")
      end
      after(:all) do
        comment.destroy if comment
      end
    end
    #TODO handle pull failures  
    context "when creation fails because the comment isn't found" do
    end
  end
  
  describe ".update_comment" do
    let(:user) { User.first } 
    let(:comment_parent) { Collection.first }
    subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                   parent_type: "Collection", body: "comment") }
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                        sync_object_site_id: comment.site_id)
        parameters_values_hash = { body: "new comment", updated_at: Time.now }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        comment.reload
      end
      it "updates 'body'" do
        expect(comment.body).to eq("new comment")
      end
      after(:all) do
        comment.destroy if comment
      end
    end
    
    #TODO handle pull failures    
    context "when update fails because the comment is not found" do
    end
    
    # handle synchronization conflict: last update wins
    context "when update fails because there is a newer update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, text_last_updated_at: Time.now)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                        sync_object_site_id: comment.site_id)
        parameters_values_hash = { body: "new comment", updated_at: comment.text_last_updated_at - 2 } 
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        comment.reload
      end
      it "doesn't update 'body'" do
        expect(comment.body).to eq("comment")
      end
      after(:all) do
        comment.destroy if comment
      end
    end
  end
  
  describe ".delete_comment" do
    let(:user) { User.first }
    let(:comment_parent) { Collection.first }
    subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                   parent_type: "Collection", body: "comment") }
                                   
    context "when successful deletion" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                        sync_object_site_id: comment.site_id)
        parameters_values_hash = { deleted: 1 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        comment.reload
      end
      it "deletes comment" do        
        expect(comment.deleted).to eq(1)
      end
      after(:all) do
        comment.destroy if comment
      end
    end
    #TODO handle pull failures  
    context "when deletion fails because the comment isn't found" do
    end
  end
   
  describe ".hide_comment" do
    let(:user) { User.first }
    let(:comment_parent) { Collection.first }
    subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                   parent_type: "Collection", body: "comment") }
                                   
    context "when successful hide" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.hide.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                        sync_object_site_id: comment.site_id)
        sync_peer_log.process_entry
        comment.reload
      end
      it "has correct 'visible_at'" do
        expect(comment.visible_at).to be_nil
      end
      after(:all) do
        comment.destroy if comment
      end
    end
    #TODO handle pull failures  
    context "when hide fails because the comment isn't found" do
    end
  end
  
  describe ".show_comment" do
    let(:user) { User.first }
    let(:comment_parent) { Collection.first }
    subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                   parent_type: "Collection", body: "comment",
                                   visible_at: nil) }
                                   
    context "when successful show" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                        sync_object_site_id: comment.site_id)
        parameters_values_hash = { visible_at: Time.now }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        comment.reload
      end
      it "has correct 'visible_at'" do
        expect(comment.visible_at).not_to be_nil
      end
      after(:all) do
        comment.destroy if comment
      end
    end
    
    # handle synchronization conflict: last update wins
    context "when show fails because there is a newer show" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, visible_at: Time.now)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                        user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                        sync_object_site_id: comment.site_id)
        parameters_values_hash = { visible_at: comment.visible_at - 2 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        comment.reload
      end
      it "doesn't update 'visible_at'" do
        expect(comment.visible_at).not_to eq(comment.visible_at - 2)
      end
      after(:all) do
        comment.destroy if comment
      end
    end
    
    #TODO handle pull failures  
    context "when show fails because the comment isn't found" do
    end
  end
end