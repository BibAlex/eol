class CreateSyncPeerLogs < ActiveRecord::Migration
  def self.up
  	create_table :sync_peer_logs do |t|
  	  t.integer  :user_site_id
  	  t.integer  :user_site_object_id
  	  t.datetime :action_taken_at_time, :null => false
  	  t.integer  :sync_object_action_id, :null => false
  	  t.integer  :sync_object_type_id, :null => false
  	  t.integer  :sync_object_id, :null => false
  	  t.integer  :sync_object_site_id, :null => false
  	  t.integer  :sync_event_id
  	  t.timestamps
  	end
  end

  def self.down
  	drop_table :sync_peer_logs 
  end
end
