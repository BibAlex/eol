class FillSyncIdsUser < ActiveRecord::Migration
  def up
    User.connection.execute("update users set user_origin_id=id, site_id=1;")
  end

  def down
  end
end
