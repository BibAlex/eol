class SyncEventsController < ApplicationController

  def query
  	sync_event = SyncEvent.find(:last, :conditions => "status is null")

  	if (!sync_event)
  	  @message = "No pending push was found"
  	else
  	  parameters = "?uuid=#{sync_event.UUID}"
  	  # Now send the request to the registry
	  url = URI.parse(REGISTRY_URL + REGISTRY_PUSH_QUERY_URL + parameters)
	  resp=Net::HTTP.get_response(url)

	  # get the response and do the validation
	  resp_json = JSON.parse(resp.body)

	  if (resp_json["success"] == '')
	  	message = "Push #{sync_event.UUID} is still being processed"
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