class CreateSyncUuids < ActiveRecord::Migration
  def up
    create_table :sync_uuids do |t|
      t.string :current_uuid

      t.timestamps
    end
  end

  def down
    drop_table :sync_uuids
  end
end
