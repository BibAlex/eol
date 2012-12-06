class UpdateUserSites < ActiveRecord::Migration
  def self.up
  	# Set default site_id and user_site_object_id for users
  	User.connection.execute("update users set user_site_object_id=id, site_id=#{PEER_SITE_ID};")
  end

  def self.down
  	User.connection.execute("update users set user_site_object_id=Null, site_id=Null;")
  end
end
