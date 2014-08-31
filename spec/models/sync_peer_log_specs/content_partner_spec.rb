require "spec_helper"
  
describe ContentPartner do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    ContentPartnerStatus.create_enumerated
  end
  
  describe ".update_content_partner" do
    let(:content_partner) { ContentPartner.gen(content_partner_status_id: ContentPartnerStatus.active.id,
      :user => user, :full_name => 'Test content partner', updated_at: Time.now) }
    let(:user) { User.first }
    before do
      content_partner.update_attributes(origin_id: content_partner.id, site_id: PEER_SITE_ID)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.content_partner.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: content_partner.origin_id, 
                                      sync_object_site_id: content_partner.site_id)
      parameters_values_hash = { partner_user_origin_id: user.origin_id,
                                 partner_user_site_id: user.site_id,
                                 full_name: "updated_full_name", 
                                 acronym: "updated_acronym", 
                                 display_name: "updated_display_name", 
                                 homepage: "updated_homepage", 
                                 description: "updated_description", 
                                 description_of_data: "updated_description_of_data", 
                                 notes: "updated_notes", 
                                 admin_notes: "updated_admin_notes",
                                 "public" => 1 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "updates content partner" do
      partner = ContentPartner.find(content_partner.id)
      expect(partner.full_name).to eq("updated_full_name")
      expect(partner.acronym).to eq("updated_acronym")
      expect(partner.user_id).to eq(user.id)
      expect(partner.display_name).to eq("updated_display_name")
      expect(partner.homepage).to eq("updated_homepage")
      expect(partner.description).to eq("updated_description")
      expect(partner.description_of_data).to eq("updated_description_of_data")
      expect(partner.notes).to eq("updated_notes")
      expect(partner.admin_notes).to eq("updated_admin_notes")
      expect(partner.public).to eq(true)
    end
  end
end