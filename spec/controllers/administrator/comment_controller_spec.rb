require File.dirname(__FILE__) + '/../../spec_helper'

describe Administrator::CommentController do
  
  describe "update comment synchronization" do
    before(:each) do
      truncate_all_tables
      SpecialCollection.create_enumerated
      @admin = User.gen(:username => "admin", :password => "admin")
      @admin[:origin_id] = @admin.id
      @admin[:site_id] = PEER_SITE_ID
      @admin.save
      @admin.grant_admin 
      session[:user_id] = @admin.id
      @comment_parent = Collection.create(:name => "collection")
      @comment_parent[:origin_id] = @comment_parent.id
      @comment_parent[:site_id] = PEER_SITE_ID
      @comment_parent.save  
      @comment = Comment.create({"user_id" => @admin.id, "parent_type"=>"Collection", "parent_id"=>"#{@comment_parent.id}", "reply_to_type"=>"",
       "reply_to_id"=>"", "body"=>"comment_on_collection", "from_curator"=>"0", "visible_at"=> Time.now, "hidden"=>"0"})      
      @comment[:origin_id] = @comment.id
      @comment[:site_id] = PEER_SITE_ID
      @comment.save
    end
              
    it "should save updating comment parameters in synchronization tables" do
      put :update, {:id => @comment.id, :comment => {"body"=>"new text"}}
     # new created collection
      updated_comment =  @comment.reload
      updated_comment.body.should == 'new text'          
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Comment"

      # check sync_object_actions
      update_action = SyncObjectAction.first
      update_action.should_not be_nil
      update_action.object_action.should == "update"
      
      # check peer log creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == update_action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == PEER_SITE_ID
      peer_log.user_site_object_id.should == @admin.id
      peer_log.sync_object_id.should == @comment.origin_id
      peer_log.sync_object_site_id.should == PEER_SITE_ID

      # check log action parameters
      # parameters for new collection
      comment_body_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "body")
      comment_body_parameter[0][:value].should == "new text"
    end        
   end
   
   describe "hide comment synchronization" do
    before(:each) do
      truncate_all_tables
      SpecialCollection.create_enumerated
      @admin = User.gen(:username => "admin", :password => "admin")
      @admin[:origin_id] = @admin.id
      @admin[:site_id] = PEER_SITE_ID
      @admin.save
      @admin.grant_admin 
      session[:user_id] = @admin.id
      @comment_parent = Collection.create(:name => "collection")
      @comment_parent[:origin_id] = @comment_parent.id
      @comment_parent[:site_id] = PEER_SITE_ID
      @comment_parent.save  
      @comment = Comment.create({"user_id" => @admin.id, "parent_type"=>"Collection", "parent_id"=>"#{@comment_parent.id}", "reply_to_type"=>"",
       "reply_to_id"=>"", "body"=>"comment_on_collection", "from_curator"=>"0", "visible_at"=> Time.now, "hidden"=>"0"})      
      @comment[:origin_id] = @comment.id
      @comment[:site_id] = PEER_SITE_ID
      @comment.save
    end
              
    it "should save hide comment parameters in synchronization tables" do
      put :hide, {:id => @comment.id}
     # new created collection
      updated_comment =  @comment.reload
      updated_comment.visible_at.should be_nil     
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Comment"

      # check sync_object_actions
      hide_action = SyncObjectAction.first
      hide_action.should_not be_nil
      hide_action.object_action.should == "hide"
      
      # check peer log creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == hide_action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == PEER_SITE_ID
      peer_log.user_site_object_id.should == @admin.id
      peer_log.sync_object_id.should == @comment.origin_id
      peer_log.sync_object_site_id.should == PEER_SITE_ID

    end        
   end
  
end