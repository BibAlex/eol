class UpdateLastUpdatedAtComment < ActiveRecord::Migration
  def up
    rename_column :comments, :last_updated_at, :text_last_updated_at
  end
end
