class ChangeUserOriginId < ActiveRecord::Migration
  def up
     rename_column :users, :user_origin_id, :origin_id
  end

  def down
  end
end
