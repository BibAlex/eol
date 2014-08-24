class AddSyncIdsToSearchLog < ActiveRecord::Migration
  
  def change
    SearchLog.connection.execute("ALTER TABLE search_logs ADD origin_id integer")
    SearchLog.connection.execute("ALTER TABLE search_logs ADD site_id integer")
  end
end