class ChangeCollectionOriginId < ActiveRecord::Migration
  def up
     rename_column :collections, :collection_origin_id, :origin_id
  end

  def down
  end
end
