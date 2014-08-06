class AddSyncIdsToContentUpload < ActiveRecord::Migration
  def change
    add_column :content_uploads, :origin_id, :integer
    add_column :content_uploads, :site_id, :integer
  end
end
