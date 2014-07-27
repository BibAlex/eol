class AddSyncIdsToContentPartnerAgreements < ActiveRecord::Migration
  def change
    add_column :content_partner_agreements, :origin_id, :integer
    add_column :content_partner_agreements, :site_id, :integer
  end
end
