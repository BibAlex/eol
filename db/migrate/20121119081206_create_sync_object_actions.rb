class CreateSyncObjectActions < ActiveRecord::Migration
  def self.up
    create_table :sync_object_actions do |t|
      t.string :object_action

      t.timestamps
    end
  end
  def self.down
  	drop_table :sync_object_actions
  end
end
