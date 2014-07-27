class AddSyncIdsToContentPartners < ActiveRecord::Migration
  def change
    add_column :content_partners, :origin_id, :integer
    add_column :content_partners, :site_id, :integer
  end
end
