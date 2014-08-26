class AddRequestPublishAtToHierarchies < ActiveRecord::Migration
  def change
    add_column :hierarchies, :request_publish_at, :datetime
  end
end
