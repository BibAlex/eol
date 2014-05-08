class RenameColumnName < ActiveRecord::Migration
  def up
    rename_column :taxon_concept_names, :updated_at, :last_change
  end

  def down
  end
end
