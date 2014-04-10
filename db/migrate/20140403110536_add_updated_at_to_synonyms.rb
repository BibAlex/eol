class AddUpdatedAtToSynonyms < ActiveRecord::Migration
  def change
    add_column :synonyms, :updated_at, :datetime
  end
end
