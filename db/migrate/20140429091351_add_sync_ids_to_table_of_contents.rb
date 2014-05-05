class AddSyncIdsToTableOfContents < ActiveRecord::Migration
  def change
    add_column :table_of_contents, :origin_id, :integer
    add_column :table_of_contents, :site_id, :integer
  end
end
