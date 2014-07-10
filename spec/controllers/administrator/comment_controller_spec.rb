require File.dirname(__FILE__) + '/../../spec_helper'

describe Administrator::CommentController do
  describe "synchronization" do
    before(:all) do
      truncate_all_tables
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
    end
    
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.first }
      let(:admin) { User.gen(username: "admin", password: "admin") }
      let(:comment_parent) { Collection.gen(name: "collection") }
      subject(:comment) { Comment.gen(body: "comment_on_collection", parent: comment_parent,
                                     parent_type: "Collection") }
      
      context "successful update" do
        
        before do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          session[:user_id] = admin.id
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          admin.grant_admin 
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
          expect(peer_log.user_site_object_id).to eq(admin.origin_id)
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
      
      context "failed update: only admins can perform this action" do
        before do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          session[:user_id] = admin.id
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          expect{ put :update, { id: comment.id, comment: { body: "new text" } } }.to raise_error(EOL::Exceptions::SecurityViolation)
        end
        
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "PUT #hide" do
      let(:peer_log) { SyncPeerLog.first }
      let(:admin) { User.gen(username: "admin", password: "admin") }
      let(:comment_parent) { Collection.gen(name: "collection") }
      subject(:comment) { Comment.gen(body: "comment_on_collection", parent: comment_parent,
                                     parent_type: "Collection") }
      
      context "successful hide" do
        
        before do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          session[:user_id] = admin.id
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          admin.grant_admin
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          @request.env['HTTP_REFERER'] = 'http://localhost:300#{PEER_SITE_ID}/administrator/comment'
          put :hide, { id: comment.id, test: true }
        end
        
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.hide.id)
        end
        
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.comment.id)
        end
        
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(comment.origin_id)
        end
      end
      
      context "failed hide only admins can perform this action" do
        before do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          session[:user_id] = admin.id
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          expect{ put :hide, { id: comment.id, test: true } }.to raise_error(EOL::Exceptions::SecurityViolation)
        end
        
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "PUT #show" do
      let(:peer_log) { SyncPeerLog.first }
      let(:admin) { User.gen(username: "admin", password: "admin") }
      let(:comment_parent) { Collection.gen(name: "collection") }
      subject(:comment) { Comment.gen(body: "comment_on_collection", parent: comment_parent,
                                     parent_type: "Collection") }
      
      context "successful show" do
        
        before do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          session[:user_id] = admin.id
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          admin.grant_admin
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          @request.env['HTTP_REFERER'] = 'http://localhost:300#{PEER_SITE_ID}/administrator/comment'
          put :show, { id: comment.id, test: true }
        end
        
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.show.id)
        end
        
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.comment.id)
        end
        
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(admin.origin_id)
        end
        
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(comment.origin_id)
        end
      end
      
      context "failed hide only admins can perform this action" do
        before do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          session[:user_id] = admin.id
          admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          expect{ put :hide, { id: comment.id, test: true } }.to raise_exception(EOL::Exceptions::SecurityViolation)
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