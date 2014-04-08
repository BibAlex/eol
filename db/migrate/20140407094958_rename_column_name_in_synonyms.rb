class RenameColumnNameInSynonyms < ActiveRecord::Migration
  def up
    rename_column :synonyms, :updated_at, :last_change
  end

  def down
  end
end
