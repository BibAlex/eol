require "spec_helper"

describe SyncPeerLog do
  
  describe "process pull" do
    describe "pulling create user action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        @prev_count = EOL::GlobalStatistics.solr_count('User')
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'create')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'User')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = 2
        @peer_log.user_site_object_id = 80
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('User').id
        @peer_log.sync_object_id = 80
        @peer_log.sync_object_site_id = 2
        @peer_log.save
        #create sync_action_parameters
        
        parameters = ["language", "validation_code", "remote_ip", "user_origin_id", "site_id", "username", "agreed_with_terms"]
        values = ["en", "89accf204c74d07fbdb1c2bad027946818142efb", "127.0.0.1", "80", "2", "user100", "1"]
        
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
        #call process entery
        @peer_log.process_entry
      end
      
      it "should create user" do
        User.count.should == 1
        user = User.first
        #user must not have a password or an email  
        user.email.should be_nil
        user.hashed_password.should be_nil
        
        user.username.should == "user100"
        user.language_id.should == Language.find_by_iso_639_1("en").id
        user.validation_code.should ==  "89accf204c74d07fbdb1c2bad027946818142efb"
        user.remote_ip.should == "127.0.0.1"
        user.user_origin_id.should == 80
        user.site_id.should == 2
        user.username.should == "user100"
        user.agreed_with_terms == 1
      end
        
      it "should update global statistics" do
        Rails.cache.read(EOL::GlobalStatistics.key_for_type("users")).should == @prev_count + 1
      end
     
    end
  end
end