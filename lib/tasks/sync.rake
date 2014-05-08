require File.dirname(__FILE__) + "/../../app/models/sync_event"
require File.dirname(__FILE__) + "/../sync"
require 'net/http'
require 'uri'
require 'socket'
require 'digest/md5'
require 'json'

namespace :sync do
  
  desc 'Make a push request with the new actions'
  task :push => :environment do
    # check if there is any pending push
    sync_event_count = SyncEvent.count(:all, :conditions => "status is null")
    if (sync_event_count > 0)
      puts 'Failed: A push request is in progress'
    else

      # Create the push
      sync_event = SyncEvent.create_push_event
      parameters = "?auth_code=#{AUTH_CODE}&current_uuid=#{SyncUuid::get_current_uuid}&file_url=#{SITE_URI}#{sync_event.file_url}&file_md5_hash=#{SITE_URI}#{sync_event.file_md5_hash}"
      
      # Now send the request to the registry
      url = URI.parse(REGISTRY_URL + REGISTRY_PUSH_URL + parameters)
      resp=Net::HTTP.get_response(url)
      
      if (resp.code == '200')      
        # get the response and do the validation
        resp_json = JSON.parse(resp.body)
        
        sync_event.UUID = resp_json["uuid"]
        sync_event.received_at = resp_json["received_at"]
        sync_event.save
        puts "Push Success"      
      else
        resp_json = JSON.parse(resp.body) unless resp.code != '404' && resp.code != '500'  
        
        # failed
        sync_event.release_logs()
        sync_event.status = 0
        sync_event.failed_reason = resp_json["message"] if resp_json
        sync_event.status_code = resp.code
        sync_event.save
        if resp_json
          puts "Error: #{resp.code} #{resp_json["message"]}"
        else
          puts "Error: #{resp.code}"
        end
      end
    end  
  end

  desc 'Query last pending push for results'
  task :query_push => :environment do
    sync_event = SyncEvent.find(:last, :conditions => "status is null")

    if (!sync_event)
      puts "No pending push was found"
    else
      parameters = "?uuid=#{sync_event.UUID}"
      # Now send the request to the registry
      url = URI.parse(REGISTRY_URL + REGISTRY_PUSH_QUERY_URL + parameters)
      resp=Net::HTTP.get_response(url)

      # get the response and do the validation
      resp_json = JSON.parse(resp.body)

      if (!resp_json["success"])
        puts "Push #{sync_event.UUID} is still being processed"
      else
        if (resp_json["success"] == 0)
          sync_event.release_logs()
          sync_event.status = 0
          sync_event.failed_reason = resp_json["failed_reason"]
          sync_event.failed_at = resp_json["failed_at"]
          sync_event.save
          puts "Push #{sync_event.UUID} Failed"
          puts "Reason: #{sync_event.failed_reason}"
        else
          sync_event.status = 1
          sync_event.success_at = resp_json["success_at"]
          sync_event.save
          SyncUuid::set_uuid(sync_event.UUID)
          puts "Push #{sync_event.UUID} success"
        end
      end
    end
  end
  
  desc 'Send a pull request'
  task :pull => :environment do
    sync_event = SyncEvent.create_pull_event
    
    parameters = "?auth_code=#{AUTH_CODE}&current_uuid=#{SyncUuid::get_current_uuid}"
    
    # Now send the request to the registry
    url = URI.parse(REGISTRY_URL + REGISTRY_PULL_URL + parameters)
    resp=Net::HTTP.get_response(url)
    
    # get the response and do the validation
    resp_json = JSON.parse(resp.body)
    
    if (resp.code == '200')
      file_name = File.join(Rails.root, "public", "files", "sync_logs", "#{sync_event.id}")
      uuid_to_be = resp_json["UUID"]
      
      # Download File
      unless Sync.download_file?(resp_json["file_url"], "#{file_name}.json")
        Sync.pull_failed(sync_event, uuid_to_be, "Unable to download file #{resp_json["file_url"]}.json", '462 ') && return   # 462: Destination Unreachable
      end
      
      # Download checksum file
      unless Sync.download_file?(resp_json["file_md5_hash"], "#{file_name}.md5")
        Sync.pull_failed(sync_event, uuid_to_be, "Unable to download file #{resp_json["file_md5_hash"]}.md5", '462 ') && return   # 462: Destination Unreachable
      end
      
      # validate the md5 checksum
      unless Sync.validate_md5?("#{file_name}.json", "#{file_name}.md5")
        Sync.pull_failed(sync_event, uuid_to_be, "Invalid md5 checksum", '500') && return
      end
      
      # Start importing data
      Sync.process_pull(sync_event, "#{file_name}.json")
      
      # Save & notify the registry
      Sync.pull_success(sync_event, uuid_to_be)    
    else
      Sync.pull_failed(sync_event, "", resp_json["message"], resp.code) && return  
    end    
  end
end