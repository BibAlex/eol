class SyncLogActionParameter < ActiveRecord::Base

  belongs_to :SyncPeerLog
  belongs_to :SyncObjectType, :foreign_key => 'param_object_type_id'
  belongs_to :SyncObjectAction, :foreign_key => 'param_object_action_id'
  belongs_to :SyncPeerLog, :foreign_key => 'peer_log_id'

end