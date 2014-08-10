class AddSwapUpdatedAtToForums < ActiveRecord::Migration
  def change
    add_column :forums, :swap_updated_at, :datetime
  end
end
