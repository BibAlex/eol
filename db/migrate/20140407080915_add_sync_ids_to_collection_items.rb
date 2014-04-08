class AddSyncIdsToCollectionItems < ActiveRecord::Migration
 def change
    add_column :collection_items, :origin_id, :integer
    add_column :collection_items, :site_id, :integer
  end
end
