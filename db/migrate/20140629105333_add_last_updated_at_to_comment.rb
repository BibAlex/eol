class AddLastUpdatedAtToComment < ActiveRecord::Migration
  def change
    add_column :comments, :last_updated_at, :datetime
  end
end
