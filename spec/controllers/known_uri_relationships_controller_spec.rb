require "spec_helper"

describe KnownUriRelationshipsController do
  before(:all) do
    load_foundation_cache
    @user = User.gen
    @user.grant_permission(:see_data)
    @full = FactoryGirl.create(:curator)
    @full.grant_permission(:see_data)
    @master = FactoryGirl.create(:master_curator)
    @master.grant_permission(:see_data)
    @admin = User.gen(:admin => true)
    @admin.grant_permission(:see_data)
    # creating some allowed units for Mass
    @mass = KnownUri.gen_if_not_exists({ uri: Rails.configuration.uri_term_prefix + 'mass', name: 'Mass', uri_type_id: UriType.measurement.id })
    @length = KnownUri.gen_if_not_exists({ uri: Rails.configuration.uri_term_prefix + 'length', name: 'Length', uri_type_id: UriType.measurement.id })
    @sex = KnownUri.find_by_translated(:name, 'Sex')
    @male = KnownUri.find_by_translated(:name, 'Male')
    @female = KnownUri.find_by_translated(:name, 'Female')
    @source = KnownUri.find_by_translated(:name, 'Source')
    [ KnownUri.milligrams, KnownUri.grams, KnownUri.kilograms ].each do |unit|
      KnownUriRelationship.gen(from_known_uri: @mass, to_known_uri: unit,
        relationship_uri: KnownUriRelationship::ALLOWED_UNIT_URI)
    end
  end
  
  describe "synchronization" do
    before(:all) do
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
    end
      
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:known_uri_relationship) { KnownUriRelationship.last }
      let(:from_known_uri) { KnownUri.first }
      let(:to_known_uri) { KnownUri.last }
      
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          from_known_uri.update_attributes(origin_id: from_known_uri.id, site_id: PEER_SITE_ID)
          to_known_uri.update_attributes(origin_id: to_known_uri.id, site_id: PEER_SITE_ID)
          session[:user_id] = @admin.id
          post :create,  { known_uri_relationship: { from_known_uri_id: from_known_uri.id,
                                                     relationship_uri: "http://www.w3.org/2002/07/owl#inverseOf",
                                                     to_known_uri_id: "" },
                           autocomplete: { to_known_uri: to_known_uri.uri  } }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.known_uri_relationship.id)
        end
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        it "creates sync log action parameter for 'created_at'" do
          created_at_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "created_at")
          expect(created_at_parameter[0][:value]).to eq(known_uri_relationship.created_at.utc.to_s(:db))
        end
        it "creates sync log action parameter for 'relationship_uri'" do
          relationship_uri_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "relationship_uri")
          expect(relationship_uri_parameter[0][:value]).to eq(known_uri_relationship.relationship_uri)
        end
        it "creates sync log action parameter for 'from_uri_origin_id'" do
          from_uri_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "from_uri_origin_id")
          expect(from_uri_origin_id_parameter[0][:value].to_i).to eq(from_known_uri.origin_id)
        end
        it "creates sync log action parameter for 'from_uri_site_id'" do
          from_uri_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "from_uri_site_id")
          expect(from_uri_site_id_parameter[0][:value].to_i).to eq(from_known_uri.site_id)
        end
        it "creates sync log action parameter for 'to_uri_origin_id'" do
          to_uri_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "to_uri_origin_id")
          expect(to_uri_origin_id_parameter[0][:value].to_i).to eq(to_known_uri.origin_id)
        end
        it "creates sync log action parameter for 'to_uri_site_id'" do
          to_uri_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "to_uri_site_id")
          expect(to_uri_site_id_parameter[0][:value].to_i).to eq(to_known_uri.site_id)
        end
        after do
          known_uri_relationship.destroy if known_uri_relationship
        end
      end
      
      context "when the user doesn't have  privileges to create known uri relationship" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          from_known_uri.update_attributes(origin_id: from_known_uri.id, site_id: PEER_SITE_ID)
          to_known_uri.update_attributes(origin_id: to_known_uri.id, site_id: PEER_SITE_ID)
          expect { post :create,  { known_uri_relationship: { from_known_uri_id: from_known_uri.id,
                                                     relationship_uri: "http://www.w3.org/2002/07/owl#inverseOf",
                                                     to_known_uri_id: "" },
                                    autocomplete: { to_known_uri: to_known_uri.uri  } } }.to raise_error(EOL::Exceptions::SecurityViolation)

        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          known_uri_relationship.destroy if known_uri_relationship
        end
      end
    end
    
    describe "DELETE #destroy" do
      let(:peer_log) { SyncPeerLog.first }
      subject(:known_uri_relationship) { KnownUriRelationship.gen(from_known_uri: from_known_uri,
                                                                  to_known_uri: to_known_uri,
                                                                  relationship_uri: KnownUriRelationship::ALLOWED_UNIT_URI) }
      let(:from_known_uri) { KnownUri.first }
      let(:to_known_uri) { KnownUri.last }
      
      context "when successful deletion" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          from_known_uri.update_attributes(origin_id: from_known_uri.id, site_id: PEER_SITE_ID)
          to_known_uri.update_attributes(origin_id: to_known_uri.id, site_id: PEER_SITE_ID)
          session[:user_id] = @admin.id
          @request.env['HTTP_REFERER'] = 'http://localhost:300#{PEER_SITE_ID}/known_uris/#{from_known_uri.id}/edit'
          delete :destroy,  { id: known_uri_relationship}
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.known_uri_relationship.id)
        end
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(@admin.origin_id)
        end
        it "creates sync log action parameter for 'relationship_uri'" do
          relationship_uri_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "relationship_uri")
          expect(relationship_uri_parameter[0][:value]).to eq(known_uri_relationship.relationship_uri)
        end
        it "creates sync log action parameter for 'from_uri_origin_id'" do
          from_uri_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "from_uri_origin_id")
          expect(from_uri_origin_id_parameter[0][:value].to_i).to eq(from_known_uri.origin_id)
        end
        it "creates sync log action parameter for 'from_uri_site_id'" do
          from_uri_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "from_uri_site_id")
          expect(from_uri_site_id_parameter[0][:value].to_i).to eq(from_known_uri.site_id)
        end
        it "creates sync log action parameter for 'to_uri_origin_id'" do
          to_uri_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "to_uri_origin_id")
          expect(to_uri_origin_id_parameter[0][:value].to_i).to eq(to_known_uri.origin_id)
        end
        it "creates sync log action parameter for 'to_uri_site_id'" do
          to_uri_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "to_uri_site_id")
          expect(to_uri_site_id_parameter[0][:value].to_i).to eq(to_known_uri.site_id)
        end
        after do
          known_uri_relationship.destroy if known_uri_relationship
        end
      end
      
      context "when the user doesn't have  privileges to destroy known uri relationship" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          @admin.update_attributes(origin_id: @admin.id, site_id: PEER_SITE_ID)
          from_known_uri.update_attributes(origin_id: from_known_uri.id, site_id: PEER_SITE_ID)
          to_known_uri.update_attributes(origin_id: to_known_uri.id, site_id: PEER_SITE_ID)
          expect { delete :destroy,  { id: known_uri_relationship} }.to raise_error(EOL::Exceptions::SecurityViolation)

        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          known_uri_relationship.destroy if known_uri_relationship
        end
      end
    end
    
   end
end