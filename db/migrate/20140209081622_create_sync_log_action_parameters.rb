class CreateSyncLogActionParameters < ActiveRecord::Migration
  def up
    create_table :sync_log_action_parameters do |t|
      t.integer :peer_log_id
      t.integer :param_object_type_id
      t.integer :param_object_id
      t.integer :param_object_site_id
      t.string :parameter
      t.string :value

      t.timestamps
    end
  end

  def down
    drop_table :sync_log_action_parameters
  end
end
