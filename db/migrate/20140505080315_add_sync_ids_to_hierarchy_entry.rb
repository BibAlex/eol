class AddSyncIdsToHierarchyEntry < ActiveRecord::Migration
  def change
    add_column :hierarchy_entries, :origin_id, :integer
    add_column :hierarchy_entries, :site_id, :integer
  end
end
