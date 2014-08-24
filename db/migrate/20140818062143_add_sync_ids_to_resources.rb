class AddSyncIdsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :origin_id, :integer
    add_column :resources, :site_id, :integer
  end
end
