class SyncEvent < ActiveRecord::Base
  attr_accessible :UUID, :failed_reason, :file_md5_hash, :file_url, :received_at, :site_id, :status, :success_at, :failed_at, :status_code

  def self.create_push_event
    sync_event = SyncEvent.new
    sync_event.site_id = PEER_SITE_ID    
    sync_event.save    
    
    sync_event.file_url = "/files/sync_logs/#{sync_event.id}.json"
    sync_event.file_md5_hash = "/files/sync_logs/#{sync_event.id}.md5"
    sync_event.save 

    # update all peer_log_actions with the new sync_event.id
    sync_peer_logs = SyncPeerLog.find(:all, :conditions => "sync_event_id is null", 
                                            :select => 'id, user_site_id, user_site_object_id, action_taken_at_time, 
                                                        sync_object_action_id, sync_object_type_id, 
                                                        sync_object_id, sync_object_site_id')
    
    log_list = sync_peer_logs.map do |s|
      s.sync_log_action_parameter.each do |lap|
        if lap[:parameter] == "language"
          lap[:value] = Language.find_by_id(lap[:value]).iso_639_1 if lap[:value]
        end
      end
      s.attributes.merge!(:parameters => s.sync_log_action_parameter).merge(:object_type => s.sync_object_type.object_type).merge(:object_action => s.sync_object_action.object_action)
      #TODO: need to filter columns in SyncLogActionParameter (simply remove the ID and peer_log_id)
    end

    SyncPeerLog.update_all "sync_event_id = #{sync_event.id}", "sync_event_id is null"

    # prepare file for syncing
    File.open(File.join(Rails.root, "public", "files", "sync_logs", "#{sync_event.id}.json"), 'w')  do |f| 
      f.write(log_list.to_json) 
    end

    # create checksum
    File.open(File.join(Rails.root, "public", "files", "sync_logs", "#{sync_event.id}.md5"), 'w')  do |f| 
      f.write(Digest::MD5.hexdigest(log_list.to_json))
    end

    # return sync_event
    sync_event
  end

  def release_logs
    # gets called in case a push doesn't get accepted
    # this should remove linkage between this sync_event and sync_peer_logs
    SyncPeerLog.update_all "sync_event_id=null", "sync_event_id=#{self.id}"
  end
  
  def self.create_pull_event
    sync_event = SyncEvent.new
    sync_event.site_id = 0
    sync_event.is_pull = 1    
    sync_event.save    
    
    sync_event
  end 
end