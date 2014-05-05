require "spec_helper"

describe CommentsController do  
  describe "sync events" do  
   describe "create comment synchronization" do
    before(:each) do
      truncate_all_tables
      SpecialCollection.create_enumerated
      @current_user = User.gen
      session[:user_id] = @current_user.id
      @current_user[:origin_id] = @current_user.id
      @current_user[:site_id] = PEER_SITE_ID
      @current_user.save
      @comment_parent = Collection.create(:name => "collection")
      @comment_parent[:origin_id] = @comment_parent.id
      @comment_parent[:site_id] = PEER_SITE_ID
      @comment_parent.save        
    end
              
    it "should save creating comment parameters in synchronization tables" do
      post :create, :comment => {"parent_type"=>"Collection", "parent_id"=>"#{@comment_parent.id}", "reply_to_type"=>"",
       "reply_to_id"=>"", "body"=>"comment_on_collection", "from_curator"=>"0", "visible_at"=> Time.now, "hidden"=>"0"}
     # new created collection
      new_comment =  Comment.first
      new_comment.body.should == 'comment_on_collection'          
      new_comment.user_id.should == @current_user.id
      new_comment.parent_id.should == @comment_parent.id
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Comment"

      # check sync_object_actions
      create_action = SyncObjectAction.first
      create_action.should_not be_nil
      create_action.object_action.should == "create"
      
      # check peer log creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == create_action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == PEER_SITE_ID
      peer_log.user_site_object_id.should == @current_user.id
      peer_log.sync_object_id.should == new_comment.origin_id
      peer_log.sync_object_site_id.should == PEER_SITE_ID

      # check log action parameters
      # parameters for new collection
      comment_body_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "body")
      comment_body_parameter[0][:value].should == "comment_on_collection"
      
      comment_parent_type_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "parent_type")
      comment_parent_type_parameter[0][:value].should == "Collection"
      
      comment_parent_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "comment_parent_site_id")
      comment_parent_site_id_parameter[0][:value].should == "#{@comment_parent.site_id}" 
      
      comment_parent_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "comment_parent_origin_id")
      comment_parent_origin_id_parameter[0][:value].should == "#{@comment_parent.origin_id}"
    end        
   end
   
   describe "update comment synchronization" do
    before(:each) do
      truncate_all_tables
      SpecialCollection.create_enumerated
      @current_user = User.gen
      session[:user_id] = @current_user.id
      @current_user[:origin_id] = @current_user.id
      @current_user[:site_id] = PEER_SITE_ID
      @current_user.save
      @comment_parent = Collection.create(:name => "collection")
      @comment_parent[:origin_id] = @comment_parent.id
      @comment_parent[:site_id] = PEER_SITE_ID
      @comment_parent.save  
      @comment = Comment.create({"user_id" => @current_user.id, "parent_type"=>"Collection", "parent_id"=>"#{@comment_parent.id}", "reply_to_type"=>"",
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
      peer_log.user_site_object_id.should == @current_user.id
      peer_log.sync_object_id.should == @comment.origin_id
      peer_log.sync_object_site_id.should == PEER_SITE_ID

      # check log action parameters
      # parameters for new collection
      comment_body_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "body")
      comment_body_parameter[0][:value].should == "new text"
    end        
   end 
   
   describe "delete comment synchronization" do
    before(:each) do
      truncate_all_tables
      SpecialCollection.create_enumerated
      @current_user = User.gen
      session[:user_id] = @current_user.id
      @current_user[:origin_id] = @current_user.id
      @current_user[:site_id] = PEER_SITE_ID
      @current_user.save
      @comment_parent = Collection.create(:name => "collection")
      @comment_parent[:origin_id] = @comment_parent.id
      @comment_parent[:site_id] = PEER_SITE_ID
      @comment_parent.save  
      @comment = Comment.create({"user_id" => @current_user.id, "parent_type"=>"Collection", "parent_id"=>"#{@comment_parent.id}", "reply_to_type"=>"",
       "reply_to_id"=>"", "body"=>"comment_on_collection", "from_curator"=>"0", "visible_at"=> Time.now, "hidden"=>"0"})      
      @comment[:origin_id] = @comment.id
      @comment[:site_id] = PEER_SITE_ID
      @comment.save
    end
              
    it "should save deleting comment parameters in synchronization tables" do
      delete :destroy, {:id => @comment.id, 
                        :return_to => "http://localhost:300#{PEER_SITE_ID}/collections/#{@comment_parent.id}/newsfeed#Comment-#{@comment.id}"}
     # new created collection
      updated_comment =  @comment.reload
      updated_comment.deleted.should == 1          
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Comment"

      # check sync_object_actions
      delete_action = SyncObjectAction.first
      delete_action.should_not be_nil
      delete_action.object_action.should == "delete"
      
      # check peer log creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == delete_action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == PEER_SITE_ID
      peer_log.user_site_object_id.should == @current_user.id
      peer_log.sync_object_id.should == @comment.origin_id
      peer_log.sync_object_site_id.should == PEER_SITE_ID

      # check log action parameters
      # parameters for new collection
      comment_deleted_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "deleted")
      comment_deleted_parameter[0][:value].should == "1"
      
     
    end        
   end         
  end
end