class AddSyncIdsToContentPartnerContacts < ActiveRecord::Migration
  def change
    add_column :content_partner_contacts, :origin_id, :integer
    add_column :content_partner_contacts, :site_id, :integer
  end
end
