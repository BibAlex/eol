class AddUpdatedAtToContentPages < ActiveRecord::Migration
  def change
    add_column :content_pages, :updated_at, :datetime
  end
end
