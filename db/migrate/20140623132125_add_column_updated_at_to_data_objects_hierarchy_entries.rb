class AddColumnUpdatedAtToDataObjectsHierarchyEntries < ActiveRecord::Migration
  def change
    add_column :data_objects_hierarchy_entries, :updated_at, :datetime
  end
end
