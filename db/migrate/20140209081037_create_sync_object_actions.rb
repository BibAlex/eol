class CreateSyncObjectActions < ActiveRecord::Migration
  def up
    create_table :sync_object_actions do |t|
      t.string :object_action
      t.timestamps
    end
  end

  def down
    drop_table :sync_object_actions
  end
end
