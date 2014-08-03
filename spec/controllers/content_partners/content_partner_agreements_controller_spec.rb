require File.dirname(__FILE__) + '/../../spec_helper'

describe ContentPartners::ContentPartnerAgreementsController do
  describe "synchronization" do
    before(:all) do
      load_foundation_cache
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
    end
    
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.create.id, SyncObjectType.agreement.id,
                                          agreement.origin_id, PEER_SITE_ID).first }
      subject(:agreement) { ContentPartnerAgreement.last }
      let(:content_partner) { ContentPartner.first }
      let(:user) { User.first }
      
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_partner.update_attributes(origin_id: content_partner.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          post :create, { content_partner_agreement: { body: "new_agreement", 
                                                       mou_url: "http://localhost/content/file/new_sync_file_link" },
                          content_partner_id: content_partner.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.agreement.id)
        end
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(agreement.origin_id)
        end
        it "creates sync log action parameter for 'body'" do
          body_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "body")
          expect(body_parameter[0][:value]).to eq("new_agreement")
        end
        it "creates sync log action parameter for 'mou_url'" do
          mou_url_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "mou_url")
          expect(mou_url_parameter[0][:value]).to eq("http://localhost/content/file/new_sync_file_link")
        end
        it "creates sync log action parameter for 'partner_origin_id'" do
          partner_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "partner_origin_id")
          expect(partner_origin_id_parameter[0][:value].to_i).to eq(content_partner.origin_id)
        end
        it "creates sync log action parameter for 'partner_site_id'" do
          partner_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "partner_site_id")
          expect(partner_site_id_parameter[0][:value].to_i).to eq(content_partner.site_id)
        end
      end
      
      context "when the user doesn't have  privileges to create content page" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_partner.update_attributes(origin_id: content_partner.id, site_id: PEER_SITE_ID)
          post :create, { content_partner_agreement: { body: "new_agreement", 
                                                       mou_url: "http://localhost/content/file/new_sync_file_link" },
                          content_partner_id: content_partner.id }
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
  end
end