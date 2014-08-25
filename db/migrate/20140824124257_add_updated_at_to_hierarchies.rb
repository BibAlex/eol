class AddUpdatedAtToHierarchies < ActiveRecord::Migration
  def change
    add_column :hierarchies, :updated_at, :datetime
  end
end
