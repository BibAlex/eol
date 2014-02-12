class CreateSyncObjectTypes < ActiveRecord::Migration
  def up
    create_table :sync_object_types do |t|
      t.string :object_type
      t.timestamps
    end
  end

  def down
    drop_table :sync_object_types
  end
end
