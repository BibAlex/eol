class AddSyncIdsToName < ActiveRecord::Migration
  def change
    add_column :names, :origin_id, :integer
    add_column :names, :site_id, :integer
  end
end
