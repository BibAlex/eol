class AddSyncObjectTypeAndAction < ActiveRecord::Migration
  def self.up
  	execute "insert into sync_object_types (object_type) values ('user');"
  	execute "insert into sync_object_actions (object_action) values ('add_user');"
  end

  def self.down
  	# Nothing to do
  end
end
