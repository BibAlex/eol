class FillSyncIdsLanguage < ActiveRecord::Migration
  def up
    Language.connection.execute("update languages set object_id=id, object_site_id=1;")
  end

  def down
  end
end
