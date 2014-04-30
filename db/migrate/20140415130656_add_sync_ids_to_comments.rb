class AddSyncIdsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :origin_id, :integer
    add_column :comments, :site_id, :integer
  end
end
