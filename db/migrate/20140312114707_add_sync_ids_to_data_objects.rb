class AddSyncIdsToDataObjects < ActiveRecord::Migration
  def change
    add_column :data_objects, :origin_id, :integer
    add_column :data_objects, :site_id, :integer
  end
end