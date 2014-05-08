class AddSyncIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_origin_id, :integer
    add_column :users, :site_id, :integer
  end
end
