class LogSolrActivities < ActiveRecord::Migration
  def self.up
    create_table :solr_logs do |t|
      t.string :node, :limit => 128
      t.string :action
      t.text :solr_query
      t.text :column_names
      t.string :row_separator
      t.string :column_separator
      t.timestamps
    end
    
  end

  def self.down
    drop_table :solr_logs
  end
end