class AddSiteIdToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :site_id, :integer
  	add_column :users, :user_site_object_id, :integer
  end
  def self.down
  	remove_column :users, :site_id
  	remove_column :users, :user_site_object_id
  end
end
