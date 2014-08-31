require "spec_helper"
  
describe GlossaryTerm do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_glossary_term" do
    let(:taxon_concept) { TaxonConcept.first }
    before do
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.glossary_term.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, #create a new one with this origin_id 
                                      sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = { term: "create_term", definition: "create_def" }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new glossary term with the correct parameters" do
      glossary_term = GlossaryTerm.find_by_origin_id(80)
      expect(glossary_term).not_to be_nil
      expect(glossary_term.term).to eq("create_term")
      expect(glossary_term.definition).to eq("create_def")
    end
    after do
      GlossaryTerm.find_by_origin_id(80).destroy if GlossaryTerm.find_by_origin_id(80)
    end
  end
end