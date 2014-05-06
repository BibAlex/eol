class AddSyncIdsToContentPages < ActiveRecord::Migration
  def change
    add_column :content_pages, :origin_id, :integer
    add_column :content_pages, :site_id, :integer
  end
end
