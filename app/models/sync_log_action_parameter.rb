class SyncLogActionParameter < ActiveRecord::Base
  attr_accessible :param_object_id, :param_object_site_id, :param_object_type_id, :parameter, :peer_log_id, :value

  belongs_to :sync_object_type, :foreign_key => 'param_object_type_id'
  belongs_to :sync_object_action, :foreign_key => 'param_object_action_id'
  belongs_to :sync_peer_log, :foreign_key => 'peer_log_id'
end