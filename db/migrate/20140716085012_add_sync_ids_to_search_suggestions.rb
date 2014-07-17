class AddSyncIdsToSearchSuggestions < ActiveRecord::Migration
  def change
    add_column :search_suggestions, :origin_id, :integer
    add_column :search_suggestions, :site_id, :integer
  end
end
