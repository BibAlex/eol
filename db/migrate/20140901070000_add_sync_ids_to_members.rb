class AddSyncIdsToMembers < ActiveRecord::Migration
  def change
    add_column :members, :origin_id, :integer
    add_column :members, :site_id, :integer
  end
end
