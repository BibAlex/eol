require "spec_helper"

def log_in_for_controller(controller, user)
  session[:user_id] = user.id
  controller.set_current_user = user
end

describe Administrator::SearchSuggestionController do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectAction.create_enumerated
    SyncObjectType.create_enumerated
  end
  describe "Synchronization of creating search suggestion" do
    let(:user) { User.first }
    let(:action) { SyncObjectAction.create }
    let(:type) { SyncObjectType.search_suggestion }
    let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
    let(:created_search_suggestion) { SearchSuggestion.last}
    before(:all) do
      user.update_attributes(site_id: PEER_SITE_ID, admin: 1)
      TaxonConcept.first.update_attributes(origin_id: TaxonConcept.first.id)
    end
    before do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      post :create, { search_suggestion: { term: "create_term", taxon_id: TaxonConcept.first.id, sort_order: "1", active: 1 } }
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
      expect(peer_log.user_site_id).to eq(user.site_id)
    end
    it "creates sync peer log with correct user_site_object_id" do
      expect(peer_log.user_site_object_id).to eq(user.origin_id)
    end
    it "creates sync peer log with correct sync_object_id" do
      expect(peer_log.sync_object_id).to eq(created_search_suggestion.origin_id)
    end
    it "creates sync peer log with correct sync_object_site_id" do
      expect(peer_log.sync_object_site_id).to eq(created_search_suggestion.site_id)
    end
    it "creates sync log action parameter for term" do
      term_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "term")
      expect(term_parameter[0][:value]).to eq("create_term")
    end
    it "creates sync log action parameter for taxon_concept_origin_id" do
      taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
      expect(taxon_concept_origin_id_parameter[0][:value]).to eq(TaxonConcept.first.origin_id.to_s)
    end
    it "creates sync log action parameter for taxon_concept_site_id" do
      taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
      expect(taxon_concept_site_id_parameter[0][:value]).to eq(TaxonConcept.first.site_id.to_s)
    end
    it "creates sync log action parameter for sort_order" do
      sort_order_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "sort_order")
      expect(sort_order_parameter[0][:value]).to eq("1")
    end
    after(:each) do
      SearchSuggestion.last.destroy
    end
  end
  
  describe "Synchronization of updating search suggestion" do
    let(:user) { User.first }
    let(:action) { SyncObjectAction.update }
    let(:type) { SyncObjectType.search_suggestion }
    let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
    let(:search_suggestion) { SearchSuggestion.create(term: "before_update", taxon_id: TaxonConcept.first.id, sort_order: "1", active: 1) }
    before(:all) do
      user.update_attributes(site_id: PEER_SITE_ID, admin: 1)
      TaxonConcept.first.update_attributes(origin_id: TaxonConcept.first.id)
    end
    before do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      put :update, { id: search_suggestion.id, search_suggestion: { term: "after_update", taxon_id: TaxonConcept.first.id, sort_order: "2", active: 1 } }
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
      expect(peer_log.user_site_id).to eq(user.site_id)
    end
    it "creates sync peer log with correct user_site_object_id" do
      expect(peer_log.user_site_object_id).to eq(user.origin_id)
    end
    it "creates sync peer log with correct sync_object_id" do
      expect(peer_log.sync_object_id).to eq(search_suggestion.origin_id)
    end
    it "creates sync peer log with correct sync_object_site_id" do
      expect(peer_log.sync_object_site_id).to eq(search_suggestion.site_id)
    end
    it "creates sync log action parameter for term" do
      term_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "term")
      expect(term_parameter[0][:value]).to eq("after_update")
    end
    it "creates sync log action parameter for taxon_concept_origin_id" do
      taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
      expect(taxon_concept_origin_id_parameter[0][:value]).to eq(TaxonConcept.first.origin_id.to_s)
    end
    it "creates sync log action parameter for taxon_concept_site_id" do
      taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
      expect(taxon_concept_site_id_parameter[0][:value]).to eq(TaxonConcept.first.site_id.to_s)
    end
    it "creates sync log action parameter for sort_order" do
      sort_order_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "sort_order")
      expect(sort_order_parameter[0][:value]).to eq("2")
    end
    after(:each) do
      SearchSuggestion.last.destroy
    end
  end 
end
  