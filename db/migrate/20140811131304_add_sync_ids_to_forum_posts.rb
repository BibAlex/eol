class AddSyncIdsToForumPosts < ActiveRecord::Migration
  def change
    add_column :forum_posts, :origin_id, :integer
    add_column :forum_posts, :site_id, :integer
  end
end
