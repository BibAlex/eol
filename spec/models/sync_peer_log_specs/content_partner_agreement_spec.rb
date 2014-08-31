require "spec_helper"
  
describe ContentPartnerAgreement do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_agreement" do
    let(:content_partner) { ContentPartner.first }
    subject(:agreement) { ContentPartnerAgreement.find_site_specific(100, PEER_SITE_ID)}
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user = User.first
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_partner.update_attributes(origin_id: content_partner.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.agreement.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 100, user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { body: "new_agreement", mou_url: "http://localhost/content/file/new_sync_file_link",
          partner_origin_id: content_partner.origin_id, partner_site_id: content_partner.site_id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new agreement" do
        expect(agreement).not_to be_nil          
      end
      it "has the correct 'body'" do
        expect(agreement.body).to eq("new_agreement")
      end
      it "has the correct 'mou_url'" do
        expect(agreement.mou_url).to eq("http://localhost/content/file/new_sync_file_link")
      end
      it "has the correct 'content_partner_id'" do
        expect(agreement.content_partner_id).to eq(content_partner.id)
      end
      after(:all) do
       agreement.destroy if agreement
      end
    end
  end
  
  describe ".update_agreement" do
    let(:content_partner) { ContentPartner.first }
    subject(:agreement) { ContentPartnerAgreement.gen(body: "agreement",
                                                      content_partner: content_partner) }
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user = User.first
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        content_partner.update_attributes(origin_id: content_partner.id, 
                                          site_id: PEER_SITE_ID)
        agreement.update_attributes(origin_id: agreement.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                        sync_object_type_id: SyncObjectType.agreement.id,
                                        user_site_object_id: user.origin_id, 
                                        sync_object_id: agreement.id, 
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { body: "new_agreement", 
                                   mou_url: "http://localhost/content/file/updated_sync_file_link",
                                   partner_origin_id: content_partner.origin_id, 
                                   partner_site_id: content_partner.site_id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        agreement.reload
      end
      it "updates agreement" do
        expect(agreement).not_to be_nil          
      end
      it "updates 'body'" do
        expect(agreement.body).to eq("new_agreement")
      end
      it "updates 'mou_url'" do
        expect(agreement.mou_url).to eq("http://localhost/content/file/updated_sync_file_link")
      end
      it "has the correct 'content_partner_id'" do
        expect(agreement.content_partner_id).to eq(content_partner.id)
      end
      after(:all) do
       agreement.destroy if agreement
      end
    end
  end
end