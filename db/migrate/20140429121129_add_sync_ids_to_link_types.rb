class AddSyncIdsToLinkTypes < ActiveRecord::Migration
  def change
    add_column :link_types, :origin_id, :integer
    add_column :link_types, :site_id, :integer
  end
end
