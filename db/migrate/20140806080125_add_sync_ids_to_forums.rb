class AddSyncIdsToForums < ActiveRecord::Migration
  def change
    add_column :forums, :origin_id, :integer
    add_column :forums, :site_id, :integer
  end
end
