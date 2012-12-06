require File.dirname(__FILE__) + "/../../app/models/sync_event"
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

	  # get the response and do the validation
	  resp_json = JSON.parse(resp.body)

	  puts resp_json

	  if (resp_json["success"] == 0)
	    # failed
	    sync_event.release_logs()
	    sync_event.status = 0;
	    sync_event.failed_reason = resp_json["message"]
	    sync_event.save
	  else
	    sync_event.UUID = resp_json["uuid"]
	    sync_event.save
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

	  if (resp_json["success"] == '')
	  	puts "Push #{sync_event.UUID} is still being processed"
	  else
	  	if (resp_json["success"] == 0)
	  	  sync_event.release_logs()
		  sync_event.status = 0;
		  sync_event.failed_reason = resp_json["message"]
		  sync_event.save
	  	else
 		  sync_event.status = 1;
	      sync_event.save
	      SyncUuid::set_uuid(sync_event.UUID)
	  	end
	  end
  	end
  end
end