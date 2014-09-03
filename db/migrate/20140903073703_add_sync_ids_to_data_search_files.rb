class AddSyncIdsToDataSearchFiles < ActiveRecord::Migration
  def change
    add_column :data_search_files, :origin_id, :integer
    add_column :data_search_files, :site_id, :integer
  end
end
