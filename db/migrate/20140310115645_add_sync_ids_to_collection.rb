class AddSyncIdsToCollection < ActiveRecord::Migration
 def change
    add_column :collections, :collection_origin_id, :integer
    add_column :collections, :site_id, :integer
  end
end