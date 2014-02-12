class AddSyncIdsToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :object_id, :integer
    add_column :languages, :object_site_id, :integer
  end
end
