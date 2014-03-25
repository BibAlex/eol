class AddSyncIdsToSynonym < ActiveRecord::Migration
  def change
    add_column :synonyms, :origin_id, :integer
    add_column :synonyms, :site_id, :integer
  end
end
