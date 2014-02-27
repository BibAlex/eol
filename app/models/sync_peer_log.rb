class SyncPeerLog < ActiveRecord::Base
  attr_accessible :action_taken_at_time, :sync_event_id, :sync_object_action_id, :sync_object_id, :sync_object_site_id, :sync_object_type_id, :user_site_id, :user_site_object_id
  has_many :sync_log_action_parameter, :foreign_key => 'peer_log_id'
  belongs_to :sync_object_type, :foreign_key => 'sync_object_type_id'
  belongs_to :sync_object_action, :foreign_key => 'sync_object_action_id'

  def self.log_add_user(user_id, params)
    spl = create_sync_peer_log(PEER_SITE_ID, user_id, SyncObjectAction.get_create_action.id, SyncObjectType.get_user_type.id, PEER_SITE_ID, user_id)
    # add log action parameters
    if spl
      params.each do |key, value| 
        unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
          create_sync_log_action_parameter(spl.id, key, value)
        end
      end
    end   
  end
  
  def self.log_activate_user(user_id)
    spl = SyncPeerLog.new
    spl.user_site_id = PEER_SITE_ID    
    spl.user_site_object_id = user_id
    spl.action_taken_at_time = Time.now
    spl.sync_object_action_id = SyncObjectAction.get_activate_action.id
    spl.sync_object_type_id = SyncObjectType.get_user_type.id
    spl.sync_object_site_id = PEER_SITE_ID
    spl.sync_object_id = user_id
    
    spl.save
  end
  
  def self.log_update_user(user_id, params)
    self.handle_user_actions(user_id, params, SyncObjectAction.get_update_action.id)
  end
  
  def process_entry
    # TODO: first we need to detect conflict.
    # considering that NOW we are dealing with add users, which won't cause conflicts,
    # So I am skipping it for now
    
    parameters = {}
    sync_log_action_parameter.each do |lap|
      unless lap.param_object_type_id
        parameters[lap.parameter] = lap.value
      else
        # find the object and add it to the hash
        parameters[lap.parameter] = SyncObjectType.find_by_id(lap.param_object_type_id).object_type.constantize.find_by_object_id_and_object_site_id(lap.param_object_id, lap.param_object_site_id)
      end
    end
    
    if parameters.blank?
      # this means that the action depends only on user id and user site id
      parameters[:user_site_id] = user_site_id
      parameters[:user_site_object_id] = user_site_object_id
    end
    
    model_name = SyncObjectType.find_by_id(sync_object_type_id).object_type.downcase
    action_name = SyncObjectAction.find_by_id(sync_object_action_id).object_action.downcase
    if parameters[:language]
      parameters[:language] = Language.find_or_create_by_iso_639_1(parameters[:language])
    else
      parameters[:language] = Language.first
    end
    function_name = "#{action_name}_#{model_name}"
    "SyncPeerLog".constantize.send(function_name, parameters)
  end
  
  # def process_entry
    # # TODO: first we need to detect conflict.
    # # considering that NOW we are dealing with add users, which won't cause conflicts,
    # # So I am skipping it for now
#     
    # parameters = {}
    # sync_log_action_parameter.each do |lap|
      # unless lap.param_object_type_id
        # parameters[lap.parameter] = lap.value
      # else
        # # find the object and add it to the hash
        # parameters[lap.parameter] = SyncObjectType.find_by_id(lap.param_object_type_id).object_type.constantize.find_by_object_id_and_object_site_id(lap.param_object_id, lap.param_object_site_id)
      # end
    # end
#     
    # if parameters.blank?
      # # this means that the action depends only on user id and user site id
      # parameters[:user_site_id] = user_site_id
      # parameters[:user_site_object_id] = user_site_object_id
    # end
#     
    # model_name = SyncObjectType.find_by_id(sync_object_type_id).object_type
    # action_name = SyncObjectAction.find_by_id(sync_object_action_id).object_action
    # if parameters[:language]
      # parameters[:language] = Language.find_or_create_by_iso_639_1(parameters[:language])
    # else
      # parameters[:language] = Language.first
    # end
    # model_name.constantize.send(action_name, parameters)
  # end
  
  private
  #for any user action such as (registeration, edit profile, ...)
  # def self.handle_user_actions(user_id, params, sync_object_action_id)
    # spl = SyncPeerLog.new
    # spl.user_site_id = PEER_SITE_ID    
    # spl.user_site_object_id = user_id
    # spl.action_taken_at_time = Time.now
    # spl.sync_object_action_id = sync_object_action_id
    # spl.sync_object_type_id = SyncObjectType.get_user_type.id
    # spl.sync_object_site_id = PEER_SITE_ID
    # spl.sync_object_id = user_id
# 
    # # add log action parameters
    # if spl.save
      # params.each do |key, value| 
        # unless 'email email_confirmation entered_password entered_password_confirmation'.include? key
          # slap = SyncLogActionParameter.new
          # slap.peer_log_id = spl.id
          # slap.parameter = key
          # slap.value = value
          # slap.save
        # end
      # end
    # end
  # end
  
  def create_sync_peer_log(user_site_id, user_site_object_id, sync_object_action_id, sync_object_type_id, sync_object_site_id, sync_object_id)
    spl = SyncPeerLog.new
    spl.user_site_id = user_site_id    
    spl.user_site_object_id = user_site_object_id
    spl.action_taken_at_time = Time.now
    spl.sync_object_action_id = sync_object_action_id
    spl.sync_object_type_id = sync_object_type_id
    spl.sync_object_site_id = sync_object_site_id
    spl.sync_object_id = sync_object_id
    return spl if spl.save 
    return nil
  end
  
  def create_sync_log_action_parameter(peer_log_id, key, value)
    slap = SyncLogActionParameter.new
    slap.peer_log_id = peer_log_id
    slap.parameter = key
    slap.value = value
    slap.save
  end
  
  def create_user(parameters)
    User.create(parameters)
    EOL::GlobalStatistics.increment('users')
  end
end