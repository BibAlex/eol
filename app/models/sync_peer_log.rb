class SyncPeerLog < ActiveRecord::Base
  
  has_many :SyncLogActionParameter, :foreign_key => 'peer_log_id'
  belongs_to :SyncObjectType, :foreign_key => 'sync_object_type_id'
  belongs_to :SyncObjectAction, :foreign_key => 'sync_object_action_id'



  def self.log_add_user(user_id, params)
  	spl = SyncPeerLog.new
  	spl.user_site_id = PEER_SITE_ID    
  	spl.user_site_object_id = user_id
  	spl.action_taken_at_time = Time.now
    spl.sync_object_action_id = SyncObjectAction.get_add_user_action.id
  	spl.sync_object_type_id = SyncObjectType.get_user_type.id
  	spl.sync_object_site_id = PEER_SITE_ID
  	spl.sync_object_id = user_id

  	# add log action parameters
  	if spl.save      
  	  params.each do |key, value| 
  	  	unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
  	  	  slap = SyncLogActionParameter.new
  	  	  slap.peer_log_id = spl.id
  	  	  slap.parameter = key
  	  	  slap.value = value
  	  	  slap.save  	  	
  	  	end
  	  end
  	end
  end
end