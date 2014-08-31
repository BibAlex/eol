require "spec_helper"
  
describe SearchSuggestion do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    SpecialCollection.create_enumerated
    Visibility.create_enumerated
    Activity.create_enumerated
    ContentPartnerStatus.create_enumerated
    TocItem.gen_if_not_exists(:label => 'overview')
  end
  
  describe ".create_search_suggestion" do
    let(:taxon_concept) { TaxonConcept.first }
    before do
      user = User.first
      taxon_concept.update_attributes(origin_id: taxon_concept.id)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.search_suggestion.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, #create a new one with this origin_id 
                                      sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = { term: "create_term", taxon_id: taxon_concept.id, sort_order: "1", active: 1, 
      taxon_concept_origin_id: taxon_concept.origin_id, taxon_concept_site_id: taxon_concept.site_id }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new search suggestion with the correct parameters" do
      search_suggestion = SearchSuggestion.find_by_origin_id(80)
      expect(search_suggestion).not_to be_nil
      expect(search_suggestion.sort_order).to eq(1)
      expect(search_suggestion.taxon_id).to eq(taxon_concept.id.to_s)
    end
    after do
      SearchSuggestion.find_by_origin_id(80).destroy if SearchSuggestion.find_by_origin_id(80)
    end
  end
  
  describe ".update_search_suggestion" do
    let(:taxon_concept) { TaxonConcept.first }
    let(:search_suggestion) { SearchSuggestion.create(term: "before_update", taxon_id: TaxonConcept.first.id, sort_order: "1", active: 1) }
    before do
      user = User.first
      search_suggestion.update_attributes(origin_id: search_suggestion.id)
      taxon_concept.update_attributes(origin_id: taxon_concept.id)
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.search_suggestion.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: search_suggestion.origin_id, #create a new one with this origin_id 
                                      sync_object_site_id: search_suggestion.site_id)
      parameters_values_hash = { term: "after_update", taxon_id: taxon_concept.id, sort_order: "1", 
        active: 1, taxon_concept_origin_id: taxon_concept.origin_id, taxon_concept_site_id: taxon_concept.site_id }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "updates search suggestion" do
      updated_search_suggestion = SearchSuggestion.find_by_id(search_suggestion.id)
      expect(updated_search_suggestion.term).to eq("after_update")
    end
    after do
      SearchSuggestion.last.destroy 
    end
  end
end  