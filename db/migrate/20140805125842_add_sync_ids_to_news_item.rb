class AddSyncIdsToNewsItem < ActiveRecord::Migration
  def change
    add_column :news_items, :origin_id, :integer
    add_column :news_items, :site_id, :integer
  end
end
