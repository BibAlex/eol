class CreateSyncUuids < ActiveRecord::Migration
  def self.up
    create_table :sync_uuids do |t|
      t.string :current_uuid
      t.timestamps
    end

    execute "insert into sync_uuids (current_uuid) values ('#{INIT_UUID}');"
  end

  def self.down
  	drop_table :sync_uuids
  end
end
