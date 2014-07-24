require "spec_helper"

describe CommentsController do
  describe "synchronization" do
    before(:all) do
      truncate_all_tables
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
    end
      
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.first }
      let(:user) { User.gen }
      let(:comment_parent) { Collection.gen(name: "collection") }
      subject(:comment) { Comment.first }
      
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          post :create, comment: { parent_type: "Collection", parent_id: "#{comment_parent.id}", 
                                   reply_to_type: "", reply_to_id: "", body: "comment_on_collection",
                                   from_curator: "0", visible_at: Time.now, hidden: "0" }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.comment.id)
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
          expect(peer_log.sync_object_id).to eq(comment.origin_id)
        end
        it "creates sync log action parameter for 'body'" do
          comment_body_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "body")
          expect(comment_body_parameter[0][:value]).to eq("comment_on_collection")
        end
        it "creates sync log action parameter for 'parent_type'" do
          comment_parent_type_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "parent_type")
          expect(comment_parent_type_parameter[0][:value]).to eq("Collection")
        end
        it "creates sync log action parameter for 'comment_parent_site_id'" do
          comment_parent_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "comment_parent_site_id")
          expect(comment_parent_site_id_parameter[0][:value]).to eq("#{comment_parent.site_id}")
        end
        it "creates sync log action parameter for 'comment_parent_origin_id'" do
          comment_parent_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "comment_parent_origin_id")
          expect(comment_parent_origin_id_parameter[0][:value]).to eq("#{comment_parent.origin_id}")
        end
      end
      
      context "when creation fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          post :create, comment: { parent_type: "Collection", parent_id: "#{comment_parent.id}", 
                                   reply_to_type: "", reply_to_id: "", body: "comment_on_collection",
                                   from_curator: "0", visible_at: Time.now, hidden: "0" }
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
      
      context "when creation fails because there is other comment with the same text" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          Comment.gen(body: "comment_on_collection", parent: comment_parent, user: user,
                      parent_type: "Collection")
          post :create, comment: { parent_type: "Collection", parent_id: "#{comment_parent.id}", 
                                   reply_to_type: "", reply_to_id: "", body: "comment_on_collection",
                                   from_curator: "0", visible_at: Time.now, hidden: "0" }
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.first }
      let(:user) { User.gen }
      let(:comment_parent) { Collection.gen(name: "collection") }
      subject(:comment) { Comment.gen(body: "comment_on_collection", parent: comment_parent, user: user,
                                     parent_type: "Collection") }
      
      context "when successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          session[:user_id] = user.id
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          put :update, { id: comment.id, comment: { body: "new text" } }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.comment.id)
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
          expect(peer_log.sync_object_id).to eq(comment.origin_id)
        end
        it "creates sync log action parameter for 'body'" do
          comment_body_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "body")
          expect(comment_body_parameter[0][:value]).to eq("new text")
        end
      end
      
      context "when update fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          put :update, { id: comment.id, comment: { body: "new text" } }
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "DELETE #destroy" do
      let(:peer_log) { SyncPeerLog.first }
      let(:user) { User.gen }
      let(:comment_parent) { Collection.gen(name: "collection") }
      subject(:comment) { Comment.gen(body: "comment_on_collection", parent: comment_parent, user: user,
                                     parent_type: "Collection") }
      
      context "when successful deletion" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          session[:user_id] = user.id
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          delete :destroy, { id: comment.id, 
                            return_to: "http://localhost:300#{PEER_SITE_ID}/collections/#{comment_parent.id}/newsfeed#Comment-#{comment.id}" }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.comment.id)
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
          expect(peer_log.sync_object_id).to eq(comment.origin_id)
        end
        it "creates sync log action parameter for 'deleted'" do
          comment_deleted_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "deleted")
          expect(comment_deleted_parameter[0][:value]).to eq("1")
        end
      end
      
      context "when deletion fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users","comments","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          delete :destroy, { id: comment.id, 
                            return_to: "http://localhost:300#{PEER_SITE_ID}/collections/#{comment_parent.id}/newsfeed#Comment-#{comment.id}" }
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
  end
end