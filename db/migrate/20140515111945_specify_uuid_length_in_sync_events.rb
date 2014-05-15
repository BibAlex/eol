class SpecifyUuidLengthInSyncEvents < ActiveRecord::Migration
  def up
    change_column :sync_events, :UUID, :string, :limit => 36
  end

  def down
  end
end
