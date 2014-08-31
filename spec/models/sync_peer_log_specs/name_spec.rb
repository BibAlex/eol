require "spec_helper"
  
describe Name do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    Visibility.create_enumerated
  end
  
  describe ".add_common_name" do
    let(:user) { User.first }
    let(:hierarchy) { Hierarchy.first }
    let(:he) { HierarchyEntry.first }
    let(:sr) { SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id) }
    before do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
      user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, label: "master", rating_weight: 1).id,
                              curator_approved: 1)
      tsr = TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id)
      relation  = SynonymRelation.find_by_translated(:label, 'common name')
      ar = AgentRole.gen()
      tar = TranslatedAgentRole.gen()
      tar.update_attributes(label: "Contributor", agent_role_id: ar.id, language_id: Language.first.id)
      hierarchy.update_column(:label, 'Encyclopedia of Life Contributors')
      taxon_concept = TaxonConcept.first
      taxon_concept.update_column(:origin_id, taxon_concept.id)
      TaxonConceptPreferredEntry.create(taxon_concept_id: taxon_concept.id, hierarchy_entry_id: he.id)
      #create sync_peer_log
      @sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                       sync_object_type_id: SyncObjectType.common_name.id,
                                       user_site_object_id: user.origin_id,
                                       user_site_id: user.site_id, 
                                       sync_object_id: 80, 
                                       sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = {taxon_concept_site_id: taxon_concept.site_id, taxon_concept_origin_id: taxon_concept.origin_id,
                                string: "add_name", language: "en"}
      create_log_action_parameters(parameters_values_hash, @sync_peer_log)
    end
    it "adds new common name and its dependencies" do
     # call process entery to execute "add common name" action
     @sync_peer_log.process_entry
     name = Name.find_by_string("add_name")
     expect(name).not_to be_nil
     synonym = Synonym.find_by_name_id(name.id)
     expect(synonym).not_to be_nil
     tcn = TaxonConceptName.find_by_name_id(name.id)
     expect(tcn).not_to be_nil
   end
   after(:each) do
     TranslatedAgentRole.last.destroy if TranslatedAgentRole.last
     TaxonConceptPreferredEntry.last.destroy if TaxonConceptPreferredEntry.last
     Name.find_by_string("add_name").destroy if Name.find_by_string("add_name")
     Synonym.last.destroy if Synonym.last
     AgentRole.last.destroy if AgentRole.last
     TranslatedAgentRole.last.destroy if TranslatedAgentRole.last
     truncate_tables(["agents_synonyms"])
   end
  end
  
  describe ".update_common_name" do
    let(:user) { User.first }
    let(:he) { HierarchyEntry.first }
    let(:sr) { SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id) }
    let(:name) { Name.gen } 
    before :each do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
      user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, label: "master", rating_weight: 1).id,
                             curator_approved: 1)
      name.update_attributes(origin_id: name.id, site_id: PEER_SITE_ID)
      SynonymRelation.create(id: 1)
      tsr = TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id)
      relation  = SynonymRelation.find_by_translated(:label, 'common name')
      ar = AgentRole.gen()
      tar = TranslatedAgentRole.gen()
      tar.update_attributes(label: "Contributor", agent_role_id: ar.id, language_id: Language.first.id)
      hi = Hierarchy.gen()
      hi.update_column(:label, 'Encyclopedia of Life Contributors')
      taxon_concept = TaxonConcept.gen()
      taxon_concept.update_column(:origin_id, taxon_concept.id)
      TaxonConceptPreferredEntry.create(taxon_concept_id: taxon_concept.id, hierarchy_entry_id: HierarchyEntry.gen().id)
      tcn = TaxonConceptName.gen()
      tcn.update_attributes(taxon_concept_id: taxon_concept.id, name_id: name.id, preferred: 0)
      synonym = Synonym.gen
      synonym.update_attributes(name_id: name.id, hierarchy_id: hi.id, hierarchy_entry_id: 1,
                                synonym_relation_id: relation.id, language_id: Language.first.id,
                                site_id: PEER_SITE_ID, preferred: 0)
      #create sync_peer_log
      @sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                       sync_object_type_id: SyncObjectType.common_name.id,
                                       user_site_object_id: user.origin_id,
                                       user_site_id: user.site_id, 
                                       sync_object_id: name.origin_id, 
                                       sync_object_site_id: name.site_id)
      #create sync_action_parameters
      parameters_values_hash = {language: Language.first.iso_639_1, taxon_concept_site_id: taxon_concept.site_id,
                                taxon_concept_origin_id: taxon_concept.origin_id, string: name.string}
      create_log_action_parameters(parameters_values_hash, @sync_peer_log)
    end
    it "updates preferred column in synonym" do
      #call process entery
      @sync_peer_log.process_entry
      expect(Synonym.find_by_name_id(name.id).preferred).not_to eq(0)
    end
    it "ignores updates for deleted names" do
      truncate_tables(["synonyms"])
      #call process entery
      lambda{ @sync_peer_log.process_entry }.should_not raise_exception
      expect(Synonym.all.count).to eq(0)
    end
    after(:each) do
      Name.last.destroy if Name.last
      Synonym.last.destroy if Synonym.last
      TaxonConceptPreferredEntry.last.destroy if TaxonConceptPreferredEntry.last
      TaxonConcept.last.destroy if TaxonConcept.last
      TaxonConceptName.last.destroy if TaxonConceptName.last
      Hierarchy.last.destroy if Hierarchy.last
      AgentRole.last.destroy if AgentRole.last
      SynonymRelation.last.destroy if SynonymRelation.last
    end
  end
  
  describe ".delete_common_name" do
    let(:user) { User.first }
    let(:he) { HierarchyEntry.first }
    let(:sr) { SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id) }
    let(:name) { Name.gen } 
    let(:tc) { TaxonConcept.first }
    let(:synonym) { Synonym.gen }
    before :all do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
      user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, label: "master", rating_weight: 1).id,
                             curator_approved: 1)
      name.update_column(:origin_id, name.id)
      tc.update_column(:origin_id, tc.id)
      synonym.update_column(:origin_id, synonym.id)
      tcn = TaxonConceptName.gen()
      tcn.update_attributes(taxon_concept_id: tc.id, name_id: name.id, synonym_id: synonym.id)
      #create peer log
      @sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                                 sync_object_type_id: SyncObjectType.common_name.id,
                                                 user_site_object_id: user.origin_id,
                                                 user_site_id: user.site_id, 
                                                 sync_object_id: synonym.origin_id, 
                                                 sync_object_site_id: synonym.site_id)
      #create sync_action_parameters
      parameters_values_hash = {taxon_concept_site_id: tc.site_id, taxon_concept_origin_id: tc.origin_id}
      create_log_action_parameters(parameters_values_hash, @sync_peer_log)
      #call process entery
      @sync_peer_log.process_entry
    end
    it "deletes synonym and taxon_concept_name" do
      expect(TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(synonym.id, tc.id)).to be_nil
      expect(Synonym.find_by_id(synonym.id)).to be_nil
    end
    it "ignores deleting already deleted names" do
      truncate_tables(["synonyms"])
      #call process entery
      lambda{ @sync_peer_log.process_entry }.should_not raise_exception
      expect(Synonym.all.count).to eq(0)
    end
    after(:all) do
      Synonym.last.destroy if Synonym.last
      Name.last.destroy if Name.last
      TaxonConceptName.last.destroy if TaxonConceptName.last
    end
  end
  
  describe ".vet_common_name" do
    let(:user) { User.first }
    let(:he) { HierarchyEntry.first }
    let(:sr) { SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id) }
    let(:name) { Name.gen } 
    let(:tc) { TaxonConcept.first }
    let(:synonym) { Synonym.gen }
    before :each do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
      user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, label: "master", rating_weight: 1).id,
                             curator_approved: 1)
      name.update_column(:origin_id, name.id)
      tc.update_column(:origin_id, tc.id)
      synonym.update_column(:origin_id, synonym.id)
      tcn = TaxonConceptName.gen()
      tcn.update_attributes(taxon_concept_id: tc.id, name_id: name.id, synonym_id: synonym.id)
      #create peer log
      @sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.vet.id,
                                       sync_object_type_id: SyncObjectType.common_name.id,
                                       user_site_object_id: user.origin_id,
                                       user_site_id: user.site_id, 
                                       sync_object_id: name.origin_id, 
                                       sync_object_site_id: name.site_id)
      #create sync_action_parameters
      parameters_values_hash = {vetted_view_order: Vetted.first.view_order, taxon_concept_site_id: tc.site_id,
                                taxon_concept_origin_id: tc.origin_id, string: name.string}
      create_log_action_parameters(parameters_values_hash, @sync_peer_log)
      #call process entery
      @sync_peer_log.process_entry
    end
    it "vets common name" do
      expect(TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(synonym.id, tc.id).vetted_id).to eq(1)
      expect(Synonym.find_by_id(synonym.id).vetted_id).to eq(1)
    end
    it "ignores vetting already deleted names" do
      truncate_tables(["synonyms","taxon_concept_names"])
      #call process entery
      lambda{ @sync_peer_log.process_entry }.should_not raise_exception
      expect(Synonym.all.count).to eq(0)
    end
    after(:each) do
      Synonym.last.destroy if Synonym.last
      Name.last.destroy if Name.last
      TaxonConceptName.last.destroy if TaxonConceptName.last
    end
  end
end