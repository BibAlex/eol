class CreateSyncEvents < ActiveRecord::Migration
  def up
  	create_table :sync_events do |t|
  	  t.integer  :site_id
  	  t.string   :file_url
  	  t.string   :file_md5_hash
  	  t.datetime :success_at
  	  t.datetime :received_at
  	  t.integer  :status
  	  t.string   :failed_reason
  	  t.string   :UUID
  	  t.timestamps
  	end
  end

  def down
  	drop_table :sync_events
  end
end
