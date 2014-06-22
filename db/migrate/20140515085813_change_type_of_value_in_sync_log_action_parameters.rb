class ChangeTypeOfValueInSyncLogActionParameters < ActiveRecord::Migration
  def up
    change_column :sync_log_action_parameters, :value, :text
  end

  def down
  end
end
