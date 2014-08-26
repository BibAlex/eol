class AddSyncIdsToHierarchies < ActiveRecord::Migration
  def change
    add_column :hierarchies, :origin_id, :integer
    add_column :hierarchies, :site_id, :integer
  end
end
