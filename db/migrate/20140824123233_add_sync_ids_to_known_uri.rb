class AddSyncIdsToKnownUri < ActiveRecord::Migration
  def change
    add_column :known_uris, :origin_id, :integer
    add_column :known_uris, :site_id, :integer
  end
end
