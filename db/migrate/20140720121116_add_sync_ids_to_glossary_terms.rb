class AddSyncIdsToGlossaryTerms < ActiveRecord::Migration
  def change
    add_column :glossary_terms, :origin_id, :integer
    add_column :glossary_terms, :site_id, :integer
  end
end
