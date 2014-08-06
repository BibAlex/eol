require File.dirname(__FILE__) + '/../../spec_helper'

describe ContentPartners::ContentPartnerContactsController do

  # This is a little weird, but we have some cases where an access_denied is expected to call
  # redirect_back_or_default and if it doesn't, it will bail out on another problem. This allows us to control how
  # that works:
  class Redirection < StandardError ; end

  before(:all) do
    Language.create_english
    ContentPartnerStatus.create_enumerated
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end

  let(:content_partner) { ContentPartner.gen(full_name: 'Test content partner') }

  describe 'GET new' do
    before(:all) do
      allow(controller).to receive(:check_authentication) { false }
      @user = build_stubbed(User)
      allow(@user).to receive(:can_create?) { true }
      allow(controller).to receive(:current_user) { @user }
    end
    it 'checks authentication' do
      get :new, content_partner_id: content_partner.id
      expect(controller).to have_received(:check_authentication)
    end

    it 'assigns partner' do
      get :new, content_partner_id: content_partner.id
      expect(assigns(:partner)).to eq(content_partner)
    end

    it 'assigns contract' do
      get :new, content_partner_id: content_partner.id
      expect(assigns(:contact)).to be_a(ContentPartnerContact)
    end

    it 'denies access if user cannot create contact' do
      allow(controller).to receive(:access_denied) { 200 }
      allow(@user).to receive(:can_create?) { false }
      get :new, content_partner_id: content_partner.id
      expect(controller).to have_received(:access_denied)
    end

    it 'assigns new page_subheader' do
      get :new, content_partner_id: content_partner.id
      expect(assigns(:page_subheader)).to eq(I18n.t(:content_partner_contact_new_page_subheader))
    end

  end

  describe 'POST create' do
    before(:all) do
      allow(controller).to receive(:check_authentication) { false }
      @user = build_stubbed(User)
      allow(@user).to receive(:can_create?) { true }
      allow(controller).to receive(:current_user) { @user }
    end
    it 'checks authentication' do
      post :create, content_partner_contact: {}, content_partner_id: content_partner.id
      expect(controller).to have_received(:check_authentication)
    end

    it 'assigns partner' do
      post :create, content_partner_contact: {}, content_partner_id: content_partner.id
      expect(assigns(:partner)).to eq(content_partner)
    end

    it 'assigns contract' do
      post :create, content_partner_contact: {}, content_partner_id: content_partner.id
      expect(assigns(:contact)).to be_a(ContentPartnerContact)
    end

    it 'denies access if user cannot create contact' do
      allow(controller).to receive(:access_denied) { raise Redirection }
      allow(@user).to receive(:can_create?) { false }
      expect do
        post(:create, content_partner_contact: {}, content_partner_id: content_partner.id)
      end.to raise_error(Redirection)
    end

    context 'with a proper contact' do

      subject do
        post :create,
          content_partner_contact: build(ContentPartnerContact, content_partner: content_partner).attributes,
          content_partner_id: content_partner.id
      end

      it 'tells you it worked' do
        subject # Well, this is lame ... but it doesn't run without this line!
        expect(flash[:notice]).to eq(I18n.t(:content_partner_contact_create_successful_notice))
      end

      it 'redirects to content partner' do
        expect(subject).to redirect_to(content_partner_resources_path(content_partner))
      end

    end

    context 'with an INVALID contact' do

      subject do
        post :create,
          content_partner_contact: {},
          content_partner_id: content_partner.id
      end

      it 'tells you it failed' do
        subject # Well, this is lame ... but it doesn't run without this line!
        expect(flash.now[:error]).to eq(I18n.t(:content_partner_contact_create_unsuccessful_error))
      end

      it 'renders :new' do
        expect(subject).to render_template(:new)
      end

      it 'assigns new page_subheader' do
        subject # Sigh.
        expect(assigns(:page_subheader)).to eq(I18n.t(:content_partner_contact_new_page_subheader))
      end

    end

  end

  it 'will test all the edit stuff'

  it 'will test all the update stuff'

  it 'will test all the delete stuff'

  describe "Synchronization" do
    before(:all) do
      ContentPartnerStatus.create_enumerated
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
    end
    describe "POST #create" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.contact }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:contact) { build(ContentPartnerContact, content_partner: content_partner) }
      before do
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        content_partner.update_attributes(origin_id: content_partner.id, site_id: PEER_SITE_ID)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        post :create,
          content_partner_contact: contact.attributes,
          content_partner_id: content_partner.id
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
        expect(peer_log.sync_object_id).to eq(ContentPartnerContact.last.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(ContentPartnerContact.last.site_id)
      end
      it "creates sync log action parameter for partner_origin_id" do
        partner_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "partner_origin_id")
        expect(partner_origin_id_parameter[0][:value]).to eq(content_partner.origin_id.to_s)
      end
      it "creates sync log action parameter for partner_site_id" do
        partner_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "partner_site_id")
        expect(partner_site_id_parameter[0][:value]).to eq(content_partner.site_id.to_s)
      end
      it "creates sync log action parameter for full_name" do
        full_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "full_name")
        expect(full_name_parameter[0][:value]).to eq(ContentPartnerContact.last.full_name)
      end
      it "creates sync log action parameter for given_name" do
        given_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "given_name")
        expect(given_name_parameter[0][:value]).to eq(ContentPartnerContact.last.given_name)
      end
      it "creates sync log action parameter for email" do
        email_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "email")
        expect(email_parameter[0][:value]).to eq(ContentPartnerContact.last.email)
      end
      after(:each) do
        User.last.destroy
        ContentPartnerContact.last.destroy if ContentPartnerContact.last 
      end
    end
    
    describe "PUT #update" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.contact }
      let(:action) { SyncObjectAction.update }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:old_contact) { ContentPartnerContact.gen }
      let(:other_contact) { build(ContentPartnerContact, content_partner: content_partner) }
      before(:all) do
        content_partner.content_partner_contacts << old_contact
      end
      before do
        # any id as i will check on it later
        other_contact.update_attributes(origin_id: 100, site_id: PEER_SITE_ID) 
        old_contact.update_attributes(origin_id: old_contact.id, 
                                      site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, 
                                       site_id: PEER_SITE_ID, admin: 1)
        content_partner.update_attributes(origin_id: content_partner.id,
                                          site_id: PEER_SITE_ID)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        put :update,
          content_partner_contact: other_contact.attributes,
          content_partner_id: old_contact.content_partner.id,
          id: old_contact.id
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
        expect(peer_log.sync_object_id).to eq(100)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(other_contact.site_id)
      end
      it "creates sync log action parameter for full_name" do
        full_name_parameter = SyncLogActionParameter.where(
          peer_log_id: peer_log.id, parameter: "full_name")
        expect(full_name_parameter[0][:value]).to eq(other_contact.full_name)
      end
      it "creates sync log action parameter for given_name" do
        given_name_parameter = SyncLogActionParameter.where(
          peer_log_id: peer_log.id, parameter: "given_name")
        expect(given_name_parameter[0][:value]).to eq(other_contact.given_name)
      end
      it "creates sync log action parameter for email" do
        email_parameter = SyncLogActionParameter.where(
          peer_log_id: peer_log.id, parameter: "email")
        expect(email_parameter[0][:value]).to eq(other_contact.email)
      end
      after(:each) do
        User.last.destroy
      end
    end
    
    describe "GET #delete" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.contact }
      let(:action) { SyncObjectAction.delete }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:contact) { ContentPartnerContact.gen }
      before do
        content_partner.content_partner_contacts << contact
        contact.update_attributes(origin_id: contact.id, 
                                  site_id: PEER_SITE_ID,
                                  content_partner_id: content_partner.id)
        current_user.update_attributes(origin_id: current_user.id, 
                                       site_id: PEER_SITE_ID, admin: 1)
        content_partner.update_attributes(origin_id: content_partner.id,
                                          site_id: PEER_SITE_ID)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        get :delete,
          content_partner_id: content_partner.id,
          id: contact.id
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
        expect(peer_log.sync_object_id).to eq(contact.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(contact.site_id)
      end
      after(:each) do
        User.last.destroy
      end
    end
  end
end
