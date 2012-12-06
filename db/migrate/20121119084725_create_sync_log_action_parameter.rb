class CreateSyncLogActionParameter < ActiveRecord::Migration
  def self.up
  	create_table :sync_log_action_parameters do |t|
      t.integer  :peer_log_id
      t.integer  :param_object_type_id
      t.integer  :param_object_id
      t.integer  :param_object_site_id
      t.string   :parameter
      t.string   :value
    end
  end

  def self.down
  	drop_table :sync_log_action_parameters
  end
end
