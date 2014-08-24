require File.dirname(__FILE__) + '/../../spec_helper'

def log_in_for_controller(controller, user)
  session[:user_id] = user.id
  controller.set_current_user = user
end

describe ContentPartners::ResourcesController do

  before(:all) do
    unless @user = User.find_by_username('partner_resources_controller')
      truncate_all_tables
      Language.create_english
      CuratorLevel.create_enumerated
      ContentPartnerStatus.create_enumerated
      License.create_enumerated
      UserIdentity.create_enumerated
      @user = User.gen(:username => 'partner_resources_controller')
    end
    @content_partner = ContentPartner.gen(:user => @user, :full_name => 'Test content partner')
    @content_partner_contact = ContentPartnerContact.gen(:content_partner => @content_partner)
    @resource = Resource.gen(:content_partner => @content_partner)
  end

  describe 'GET index' do
    it 'should render root if user not logged in' do
      get :index, { :content_partner_id => @content_partner.id }
      expect(response).to redirect_to(login_url)
    end
    it 'should ask for agreement if user can update content partner and agreement is NOT accepted' do
      ContentPartnerAgreement.delete_all
      log_in_for_controller(controller, @user)
      get :index, { :content_partner_id => @content_partner.id }
      response.should redirect_to(new_content_partner_agreement_path(@content_partner))
    end
    it 'should render index if user can update content partner and agreement is accepted' do
      @content_partner_agreement = ContentPartnerAgreement.gen(:content_partner => @content_partner, :signed_on_date => Time.now)
      log_in_for_controller(controller, @user)
      get :index, { :content_partner_id => @content_partner.id }
      # not working, we're redirected and not following it...
      assigns[:partner].should == @content_partner
      assigns[:resources].should be_a(Array)
      assigns[:resources].first.should == @resource
      assigns[:partner_contacts].should be_a(Array)
      assigns[:partner_contacts].first.should == @content_partner_contact
      response.status.should == 200
      response.should render_template('content_partners/resources/index')
    end
  end

  describe 'GET new' do
    it 'should render new only if user can create content partner resources' do
      get :new, { :content_partner_id => @content_partner.id }
      response.should_not render_template('content_partners/resources/new')
      expect(response).to redirect_to(login_url)
      # Really need to have at least one license to show:
      License.last.update_attributes(show_to_content_partners: 1)
      get :new, { :content_partner_id => @content_partner.id }, { :user => @user, :user_id => @user.id }
      response.should render_template('content_partners/resources/new')
      response.status.should == 200
    end
  end

#  describe 'POST create' do
#    it 'should create resource only if user can create content partner resources'
#    it 'should rerender new on validation errors'
#    it 'should redirect to content partner resources index on success'
#    it 'should upload resource to server'
#  end

  describe 'GET edit' do
    it 'should render edit only if user can update this content partner resource' do
      get :edit, { :content_partner_id => @content_partner.id, :id => @resource.id }
      expect(response).to redirect_to(login_url)
      get :edit, { :content_partner_id => @content_partner.id, :id => @resource.id }, { :user => @user, :user_id => @user.id }
      assigns[:partner].should == @content_partner
      assigns[:resource].should == @resource
      response.should render_template('content_partners/resources/edit')
    end
  end

#  describe 'PUT update' do
#    it 'should update resource only if user can update this content partner resource'
#    it 'should rerender edit on validation errors'
#    it 'should redirect to content partner resources index on success'
#  end

  describe 'GET show' do
    it 'should render root if user not logged in' do
      get :show, { :content_partner_id => @content_partner.id, :id => @resource.id }
      expect(response).to redirect_to(login_url)
    end
    it 'should render resource show page if user can read content partner resources' do
      log_in_for_controller(controller, @user)
      get :show, { :content_partner_id => @content_partner.id, :id => @resource.id }, { :user => @user, :user_id => @user.id }
      assigns[:partner].should == @content_partner
      assigns[:resource].should == @resource
      response.should render_template('content_partners/resources/show')
    end
  end

#  describe 'GET and POST force_harvest' do
#    it 'should change resource status to force harvest only if user can update resource and state transition is allowed'
#    it 'should redirect back or default on success'
#  end
#
#  describe 'POST publish' do
#    it 'should change resource status to publish pending only if user is EOL administrator and state transition is allowed'
#    it 'should redirect back or default on success'
#  end

  describe "Synchronization" do
    before(:all) do
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      ContentPartnerStatus.create_enumerated
      License.create_enumerated
    end
    
    describe "POST #create" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.resource }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:content_partner) { ContentPartner.gen(content_partner_status_id: ContentPartnerStatus.active.id,
              :user => current_user, :full_name => 'Test content partner', updated_at: Time.now) }
      before do
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        post :create,
          resource: { title: "sync2", 
                      dataset_source_url: "", 
                      accesspoint_url: "http://eol.org/opensearchdescription.xml",
                      refresh_period_hours: "0",
                      dataset_license_id: License.no_known_restrictions.id.to_s, 
                      dataset_rights_holder: "",
                      dataset_rights_statement: "", 
                      license_id: License.no_known_restrictions.id.to_s, 
                      rights_holder: "", 
                      rights_statement: "", 
                      bibliographic_citation: "bibliographic_citation",
                      language_id: "1",
                      description: "description", 
                      auto_publish: "1",
                      vetted: "1"},
          resource_url_or_file: "url",
          content_partner_id: content_partner.id
      end
      
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates POST #createsync peer log with correct sync_object_action" do
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
        expect(peer_log.sync_object_id).to eq(Resource.last.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(Resource.last.site_id)
      end
#      it "creates sync log action parameter for page_name" do
#        page_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "page_name")
#        expect(page_name_parameter[0][:value]).to eq("un1")
#      end
#      it "creates sync log action parameter for language_id" do
#        language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
#        expect(language_id_parameter[0][:value]).to eq("1")
#      end
#      it "creates sync log action parameter for title" do
#        title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
#        expect(title_parameter[0][:value]).to eq("un1")
#      end
#      after(:each) do
#        User.find(user.id).destroy
#        NewsItem.last.destroy if NewsItem.last 
#      end
    end
    
    describe "PUT #update" do
      let(:current_user) { User.gen }
      let(:type) { SyncObjectType.resource }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:content_partner) { ContentPartner.gen(content_partner_status_id: ContentPartnerStatus.active.id,
              :user => current_user, :full_name => 'Test content partner', updated_at: Time.now) }
      let(:resource) { Resource.gen }
      context "commit_update_settings_only = true" do
        before do
          resource.update_attributes(origin_id: resource.id, site_id: PEER_SITE_ID, 
            content_partner_id: content_partner.id)
          current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          allow(controller).to receive(:current_user) { current_user }
          session[:user_id] = current_user.id
          put :update,
            resource: { title: "sync2", 
                        dataset_source_url: "", 
                        accesspoint_url: "http://eol.org/opensearchdescription.xml",
                        refresh_period_hours: "0",
                        dataset_license_id: License.no_known_restrictions.id.to_s, 
                        dataset_rights_holder: "",
                        dataset_rights_statement: "", 
                        license_id: License.no_known_restrictions.id.to_s, 
                        rights_holder: "", 
                        rights_statement: "", 
                        bibliographic_citation: "bibliographic_citation",
                        language_id: "1",
                        description: "description", 
                        auto_publish: "1",
                        vetted: "1"},
           resource_url_or_file: "url",
           commit_update_settings_only: 1,
           content_partner_id: content_partner.id,
           id: resource.id
       end
       
       it "creates sync peer log" do
         expect(peer_log).not_to be_nil
       end
       it "creates POST #createsync peer log with correct sync_object_action" do
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
         expect(peer_log.sync_object_id).to eq(resource.origin_id)
       end
       it "creates sync peer log with correct sync_object_site_id" do
         expect(peer_log.sync_object_site_id).to eq(resource.site_id)
       end
 #      it "creates sync log action parameter for page_name" do
 #        page_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "page_name")
 #        expect(page_name_parameter[0][:value]).to eq("un1")
 #      end
      end
      
      context "commit_update_settings_only = false" do
                
      end
     
    end
  end
end
