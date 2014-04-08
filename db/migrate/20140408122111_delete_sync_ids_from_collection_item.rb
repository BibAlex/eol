class DeleteSyncIdsFromCollectionItem < ActiveRecord::Migration
  def change
    remove_column :collection_items, :origin_id
    remove_column :collection_items, :site_id
  end
end
