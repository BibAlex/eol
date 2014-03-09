require "spec_helper"

describe Administrator::UserController do
  describe 'update user by admin synchronization' do
    
    before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})

        @user = User.gen(:username => 'users_controller_spec')
        @admin = User.gen(:username => "admin", :password => "admin")
        @admin.grant_admin 
        session[:user_id] = @admin.id
    end
        
     
      it 'should save approving curator paramters in synchronization tables' do 
        
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
  
  describe 'approving user to become a curator synchronization' do
    
    before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        @user = User.gen(:username => 'users_controller_spec', :requested_curator_level_id => 2, 
                                                     :credentials => "Faculty, staff, or graduate student status in a relevant university or college department",
                                                     :curator_scope => "Rodents of Borneo")
        @admin = User.gen(:username => "admin", :password => "admin")
        @admin.grant_admin 
        session[:user_id] = @admin.id
    end
        
     
      it 'should save updating user paramters in synchronization tables' do 
        
          put :update, { :id => @user.id, :user => { :id => @user.id, :username => 'newusername' , :curator_level_id => 2}}
                    
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
          
          curator_level_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "curator_level_id")
          curator_level_parameter[0][:value].should == 2.to_s
          
          curator_approved_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "curator_approved")
          curator_approved_parameter[0][:value].should == "1"
          

              
                                                                                                 
      end
  end
  
end