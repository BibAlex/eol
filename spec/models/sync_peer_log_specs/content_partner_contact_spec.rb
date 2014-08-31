require "spec_helper"
  
describe ContentPartnerContact do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_contact" do
    let(:partner) { ContentPartner.first }
    before do
      partner.update_attributes(origin_id: partner.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.contact.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, #create a new one with this origin_id 
                                      sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = { partner_origin_id: partner.origin_id.to_s, partner_site_id: partner.site_id.to_s, 
                                 given_name: "unique1string", family_name: "unique2string", 
                                 email: "unique1string.unique2string@example.com",
                                 contact_role_id: 1, homepage: "", full_name: "", address: "",
                                 telephone: "", title: "" } # any role it does not matter
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new contact with the correct parameters" do
      contact = ContentPartnerContact.find_by_origin_id(80)
      expect(contact).not_to be_nil
      expect(contact.given_name).to eq("unique1string")
      expect(contact.family_name).to eq("unique2string")
      expect(contact.contact_role_id).to eq(1)
      expect(contact.email).to eq("unique1string.unique2string@example.com")
    end
    after do
      ContentPartnerContact.find_by_origin_id(80).destroy if ContentPartnerContact.find_by_origin_id(80)
    end
  end
  
  describe ".update_contact" do
    let(:partner) { ContentPartner.gen }
    let(:contact) { ContentPartnerContact.gen }
    before do
      contact.update_attributes(origin_id: contact.id, site_id: PEER_SITE_ID)
      partner.update_attributes(origin_id: partner.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.contact.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: contact.origin_id, 
                                      sync_object_site_id: contact.site_id)
      parameters_values_hash = { given_name: "up_unique1string", family_name: "up_unique2string", 
                                 email: "up_unique1string.unique2string@example.com",
                                 contact_role_id: 1, homepage: "", full_name: "", address: "",
                                 telephone: "", title: "" } # any role it does not matter
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new contact with the correct parameters" do
      updated_contact = ContentPartnerContact.find_by_origin_id(contact.origin_id)
      expect(updated_contact).not_to be_nil
      expect(updated_contact.given_name).to eq("up_unique1string")
      expect(updated_contact.family_name).to eq("up_unique2string")
      expect(updated_contact.contact_role_id).to eq(1)
      expect(updated_contact.email).to eq("up_unique1string.unique2string@example.com")
    end
    after do
      ContentPartnerContact.find(contact.id).destroy if ContentPartnerContact.find(contact.id)
      ContentPartner.find(partner.id).destroy if ContentPartner.find(partner.id)  
    end
  end
  
  describe ".delete_contact" do
    let(:partner) { ContentPartner.gen }
    let(:contact) { ContentPartnerContact.gen }
    before(:all) do
      partner.content_partner_contacts << contact
    end
    before do
      contact.update_attributes(origin_id: contact.id, site_id: PEER_SITE_ID,
                                content_partner_id: partner.id)
      partner.update_attributes(origin_id: partner.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.contact.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: contact.origin_id, 
                                      sync_object_site_id: contact.site_id)
      parameters_values_hash = { partner_origin_id: partner.origin_id.to_s,
        partner_site_id: partner.site_id.to_s}
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "removes contact from this content partner" do
      deleted_contact = ContentPartnerContact.find_by_origin_id(contact.origin_id)
      expect(deleted_contact).to be_nil
    end
    after do
      ContentPartner.find(partner.id).destroy if ContentPartner.find(partner.id) 
    end
  end
end