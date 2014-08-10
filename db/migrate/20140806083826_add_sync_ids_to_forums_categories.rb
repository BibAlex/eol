class AddSyncIdsToForumsCategories < ActiveRecord::Migration
  def change
    add_column :forum_categories, :origin_id, :integer
    add_column :forum_categories, :site_id, :integer
  end
end
