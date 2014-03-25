class AddSyncIdsToTaxonConcept < ActiveRecord::Migration
  def change
    add_column :taxon_concepts, :origin_id, :integer
    add_column :taxon_concepts, :site_id, :integer
  end
end