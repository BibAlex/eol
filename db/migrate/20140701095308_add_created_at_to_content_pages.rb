class AddCreatedAtToContentPages < ActiveRecord::Migration
  def change
    add_column :content_pages, :created_at, :datetime
  end
end
