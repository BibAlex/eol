require "spec_helper"

describe Administrator::UserController do
  describe 'update user by admin synchronization' do
    
    before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        @user = User.gen(:username => 'users_controller_spec')
        @admin = User.gen(:username => "admin", :password => "admin")
        @admin.grant_admin 
        session[:user_id] = @admin.id
    end
        
     
      it 'should save updating user paramters in synchronization tables' do 
        
          put :update, { :id => @user.id, :user => { :id => @user.id, :username => 'newusername' }}
                    
          # check sync_object_type
          type = SyncObjectType.first
          type.should_not be_nil
          type.object_type.should == "User"
          
          # check sync_object_actions
          action = SyncObjectAction.first
          action.should_not be_nil
          action.object_action.should == "update_by_admin"
          
          # check peer logs
          peer_log = SyncPeerLog.first
          peer_log.should_not be_nil
          peer_log.sync_object_action_id.should == action.id
          peer_log.sync_object_type_id.should == type.id
          peer_log.user_site_id .should == PEER_SITE_ID
          peer_log.user_site_object_id.should == @admin.id
          peer_log.sync_object_id.should == @user.id
          peer_log.sync_object_site_id.should == PEER_SITE_ID
          
          # check log action parameters
          username_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "username")
          username_parameter[0][:value].should == "newusername"
              
                                                                                                 
      end
  end
  
end