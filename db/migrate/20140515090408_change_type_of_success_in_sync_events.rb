class ChangeTypeOfSuccessInSyncEvents < ActiveRecord::Migration
  def up
    change_column :sync_events, :status, :boolean
  end

  def down
  end
end
