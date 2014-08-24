require "spec_helper"

describe ContentPartnersController do

  # WIP

  before(:all) do
    truncate_all_tables
    Language.create_english
    CuratorLevel.create_enumerated
    UserIdentity.create_enumerated
    ContentPartnerStatus.create_enumerated
  end
  describe "Synchronization" do
    before(:all) do
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
    end
    
    describe "PUT #update" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.content_partner }
      let(:action) { SyncObjectAction.update }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:content_partner) { ContentPartner.gen(content_partner_status_id: ContentPartnerStatus.active.id,
        :user => current_user, :full_name => 'Test content partner') }
      before do
        content_partner.update_attributes(origin_id: content_partner.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        put :update,
          id: content_partner.id, 
          content_partner: { user_id: current_user.id, 
                             full_name: "updated_full_name", 
                             acronym: "updated_acronym", 
                             display_name: "updated_display_name", 
                             homepage: "updated_homepage", 
                             description: "updated_description", 
                             description_of_data: "updated_description_of_data", 
                             notes: "updated_notes", 
                             admin_notes: "updated_admin_notes",
                             "public" => 1}
      end
      
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates sync peer log with correct sync_object_action" do
        expect(peer_log.sync_object_action_id).to eq(action.id)
      end
      it "creates sync peer log with correct sync_object_type" do
        expect(peer_log.sync_object_type_id).to eq(type.id)
      end
      it "creates sync peer log with correct user_site_id" do
        expect(peer_log.user_site_id).to eq(current_user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(current_user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(content_partner.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(content_partner.site_id)
      end
      it "creates sync log action parameter for partner_user_origin_id" do
        partner_user_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "partner_user_origin_id")
        expect(partner_user_origin_id_parameter[0][:value]).to eq(current_user.origin_id.to_s)
      end
      it "creates sync log action parameter for partner_user_site_id" do
        partner_user_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "partner_user_site_id")
        expect(partner_user_site_id_parameter[0][:value]).to eq(current_user.site_id.to_s)
      end
      it "creates sync log action parameter for full_name" do
        full_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "full_name")
        expect(full_name_parameter[0][:value]).to eq("updated_full_name")
      end
      it "creates sync log action parameter for acronym" do
        acronym_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "acronym")
        expect(acronym_parameter[0][:value]).to eq("updated_acronym")
      end
      it "creates sync log action parameter for display_name" do
        display_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "display_name")
        expect(display_name_parameter[0][:value]).to eq("updated_display_name")
      end
      it "creates sync log action parameter for homepage" do
        homepage_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "homepage")
        expect(homepage_parameter[0][:value]).to eq("updated_homepage")
      end
      it "creates sync log action parameter for description" do
        description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
        expect(description_parameter[0][:value]).to eq("updated_description")
      end
      it "creates sync log action parameter for description_of_data" do
        description_of_data_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description_of_data")
        expect(description_of_data_parameter[0][:value]).to eq("updated_description_of_data")
      end
      it "creates sync log action parameter for notes" do
        notes_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "notes")
        expect(notes_parameter[0][:value]).to eq("updated_notes")
      end
      it "creates sync log action parameter for admin_notes" do
        admin_notes_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "admin_notes")
        expect(admin_notes_parameter[0][:value]).to eq("updated_admin_notes")
      end
      it "creates sync log action parameter for public" do
        public_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "public")
        expect(public_parameter[0][:value]).to eq("1")
      end
      after(:each) do
        ContentPartner.find(content_partner.id).destroy if ContentPartner.find(content_partner.id) 
      end
    end
  end
#   describe 'GET new' do
#     it 'should render new only if user can create content partner'
#   end
#
#   describe 'POST create' do
#     it 'should create content partner only if user can create content partner'
#     it 'should rerender new on validation errors'
#     it 'should redirect to show on success'
#   end
#
#   describe 'GET show' do
#     it 'should render show'
#   end
#
#   describe 'GET edit' do
#     it 'should render edit only if user can update content partner'
#   end
#
#   describe 'PUT update' do
#     it 'should update content partner only if user can update content partner'
#     it 'should rerender edit on validation errors'
#     it 'should redirect to show on success'
#   end
end
