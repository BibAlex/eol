class Sync
  
  def self.download_file?(file_url, file_name)
    begin
      url = URI.parse(file_url)
      resp=Net::HTTP.get_response(url)
      open(file_name, 'wb') do |file|
        file.write resp.body
      end
      return true
    rescue
      return false
    end
  end
  
  def self.validate_md5?(file_url, mdf_file)
    data = File.read(file_url)
    md5_checksum = Digest::MD5.hexdigest(data)
    if (md5_checksum == File.read(mdf_file))
      return true
    else
      return false
    end
  end
  
  def self.pull_failed(sync_event, uuid, reason, status_code)
    sync_event.status = 0
    sync_event.failed_reason = reason
    sync_event.failed_at = DateTime.now
    sync_event.UUID = uuid if uuid != ""
    sync_event.status_code = status_code
    sync_event.save   
    puts "Failed: #{status_code} : #{sync_event.failed_reason}"    
    notify_registry(uuid, 0, reason) if uuid != ""
  end
  
  def self.process_pull(sync_event, file_name)
    # Step 1: Fill peer_logs with the peer_logs
    import_to_peer_logs(sync_event, file_name)
    
    peer_logs = SyncPeerLog.find_all_by_sync_event_id(sync_event.id)
    
    peer_logs.each do |peer_log|
      peer_log.process_entry
    end    
  end
  
  def self.pull_success(sync_event, uuid)
    sync_event.status = 1
    sync_event.success_at = DateTime.now
    sync_event.UUID = uuid if uuid
    sync_event.save   
    puts "Pull success"    
    
    # update current_uuid
    SyncUuid.set_uuid(uuid)
    
    notify_registry(uuid, 1, "")
  end
  
  private 
  
  def self.notify_registry(uuid, success, reason)
    parameters = "?auth_code=#{AUTH_CODE}&uuid=#{uuid}&success=#{success}&reason=#{reason}"
    url = URI.parse(REGISTRY_URL + REGISTRY_PULL_REPORT + parameters)
    resp=Net::HTTP.get_response(url)
    # get the response and do the validation
    resp_json = JSON.parse(resp.body)
    #TODO: what if the registry is not available?
  end
  
  def self.import_to_peer_logs(sync_event, file_name)
    data = File.read(file_name)      
    data_json = JSON.parse(data)

    data_json.each do |data_element|
      peer_log = SyncPeerLog.new
      peer_log.sync_event_id = sync_event.id
      peer_log.user_site_id = data_element["user_site_id"]
      peer_log.user_site_object_id = data_element["user_site_object_id"]
      peer_log.action_taken_at_time = data_element["action_taken_at_time"]
      peer_log.sync_object_action_id = SyncObjectAction.find_or_create_by_object_action(data_element["sync_object_action"]).id     
      peer_log.sync_object_type_id = SyncObjectType.find_or_create_by_object_type(data_element["sync_object_type"]).id
      peer_log.sync_object_id = data_element["sync_object_id"]
      peer_log.sync_object_site_id = data_element["sync_object_site_id"]

      peer_log.save

      data_element["log_action_parameters"].each do |param|
        lap = SyncLogActionParameter.new
        lap.peer_log_id = peer_log.id
        lap.param_object_type_id = SyncObjectType.find_or_create_by_object_type(param["param_object_type"]).id if param["param_object_type"]
        lap.param_object_id = param["param_object_id"] if param["param_object_id"]
        lap.param_object_site_id = param["param_object_site_id"] if param["param_object_site_id"]
        lap.parameter = param["parameter"]
        lap.value = param["value"]

        lap.save
      end
    end
  end
end