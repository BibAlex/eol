class AddSwapUpdatedaTToContentPages < ActiveRecord::Migration
   def change
    add_column :content_pages, :swap_updated_at, :datetime
  end
end
