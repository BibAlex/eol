class AddSyncIdsToForumsTopics < ActiveRecord::Migration
  def change
    add_column :forum_topics, :origin_id, :integer
    add_column :forum_topics, :site_id, :integer
  end
end
