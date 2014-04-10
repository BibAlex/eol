class AddUpdatedAtToTaxonConceptNames < ActiveRecord::Migration
  def change
    add_column :taxon_concept_names, :updated_at, :datetime
  end
end
