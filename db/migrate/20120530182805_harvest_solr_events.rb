class HarvestSolrEvents < ActiveRecord::Migration
  def self.up
    create_table :harvest_solr_events do |t|
      t.string :node, :limit => 128
      t.integer :log_solr_activities_id
      t.timestamps
    end
  end

  def self.down
    drop table :harvest_solr_events
  end
end