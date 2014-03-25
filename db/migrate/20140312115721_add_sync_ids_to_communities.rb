class AddSyncIdsToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :origin_id, :integer
    add_column :communities, :site_id, :integer
  end
end
