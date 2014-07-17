require "spec_helper"
def create_log_action_parameters(parameters_values_hash, sync_peer_log)
  parameters_values_hash.each do |param, value|
    SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param.to_s, value: value.to_s)
  end
end
  
describe SyncPeerLog do
  before(:all) do
      truncate_all_tables
      load_foundation_cache
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
      Visibility.create_enumerated
      Activity.create_enumerated
      TocItem.gen_if_not_exists(:label => 'overview')
  end
    
  describe "common names" do
    describe ".add_common_name" do
      let(:user) { User.first }
      let(:hi) { Hierarchy.first }
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
        hi.update_column(:label, 'Encyclopedia of Life Contributors')
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
      let(:hi) { Hierarchy.first }
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
      let(:hi) { Hierarchy.first }
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
      let(:hi) { Hierarchy.first }
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
    
  describe "data_object Synchronization" do
    let(:user) { User.first }
    let(:data_object) { DataObject.first }
    let(:he) { HierarchyEntry.first }
    let(:comment) { Comment.gen }
    let(:taxon_concept) { TaxonConcept.first }
    let(:toc) { TocItem.find(TocItem.overview.id) }
    before(:all) do
      user.update_attributes(curator_approved: 1, curator_level_id: 1)
      data_object.update_attributes(origin_id: data_object.id, site_id: PEER_SITE_ID)
      he.update_attributes(origin_id: he.id, site_id: PEER_SITE_ID)
      comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
      taxon_concept.update_attributes(origin_id: taxon_concept.id, site_id: PEER_SITE_ID)
      DataObjectsTaxonConcept.create(data_object_id: data_object.id, taxon_concept_id: taxon_concept.id)
      UsersDataObject.create(user_id: user.id,
        taxon_concept_id: taxon_concept.id, 
        data_object_id: data_object.id,
        visibility_id: Visibility.invisible.id)
      toc.update_attributes(origin_id: toc.id, site_id: PEER_SITE_ID)
    end
    
    describe ".curate_association" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters","curated_data_objects_hierarchy_entries"])
        @cdoh = CuratedDataObjectsHierarchyEntry.create(vetted_id: Vetted.first.id,
                                                        visibility_id: Visibility.invisible.id, user_id: user.id, 
                                                        data_object_guid: data_object.guid, hierarchy_entry_id: he.id,
                                                        data_object_id: data_object.id) 
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.curate_associations.id,
                                        sync_object_type_id: SyncObjectType.data_object.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: data_object.origin_id, 
                                        sync_object_site_id: data_object.site_id)
        parameters_values_hash = {language: "en", vetted_view_order: 1, curation_comment_origin_id: comment.origin_id,
        curation_comment_site_id: comment.site_id, untrust_reasons: "misidentified,", visibility_label: "Visible",
        taxon_concept_origin_id: taxon_concept.origin_id, taxon_concept_site_id: taxon_concept.site_id,
        hierarchy_entry_origin_id: he.origin_id, hierarchy_entry_site_id: he.site_id}
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        #call process entery
        sync_peer_log.process_entry
      end
      it "curates association" do
        udo = UsersDataObject.find_by_user_id_and_data_object_id(user.id, data_object.id)
        expect(udo.visibility_id).to eq(Visibility.visible.id)
      end
    end
    
    describe ".add_association" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters","curated_data_objects_hierarchy_entries"])
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.save_association.id,
                                        sync_object_type_id: SyncObjectType.data_object.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: data_object.origin_id, 
                                        sync_object_site_id: data_object.site_id)
        parameters_values_hash = { hierarchy_entry_origin_id: he.origin_id, hierarchy_entry_site_id: he.site_id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        #call process entery
        sync_peer_log.process_entry
      end
      it "adds association" do
        cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(he.id, data_object.id)
        cdoh.should_not be_nil
      end
    end
    
    describe ".remove_association" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters","curated_data_objects_hierarchy_entries"])
        cdoh = CuratedDataObjectsHierarchyEntry.create(vetted_id: Vetted.first.id,
                visibility_id: Visibility.visible.id, user_id: user.id, 
                data_object_guid: data_object.guid, hierarchy_entry_id: he.id,
                data_object_id: data_object.id) 
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.remove_association.id,
                                        sync_object_type_id: SyncObjectType.data_object.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: data_object.origin_id, 
                                        sync_object_site_id: data_object.site_id)
        parameters_values_hash = { hierarchy_entry_origin_id: he.origin_id, hierarchy_entry_site_id: he.site_id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        #call process entery
        sync_peer_log.process_entry
      end
      it "removes association" do
        cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(he.id, data_object.id)
        cdoh.should be_nil
      end
    end
    
    describe ".create_data_object" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        # create sync peer log for creating ref
        create_ref_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                              sync_object_type_id: SyncObjectType.ref.id,
                                              user_site_object_id: user.origin_id,
                                              user_site_id: user.site_id)
        parameters_values_hash = { reference: "Test reference." }
        create_log_action_parameters(parameters_values_hash, create_ref_peer_log)
        #call process entery
        create_ref_peer_log.process_entry
        # create sync peer log for creating data_object
        create_data_object_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                                      sync_object_type_id: SyncObjectType.data_object.id,
                                                      user_site_object_id: user.origin_id,
                                                      user_site_id: user.site_id, 
                                                      sync_object_id: 10, 
                                                      sync_object_site_id: 10)
        parameters_values_hash = { taxon_concept_origin_id: taxon_concept.origin_id, taxon_concept_site_id: taxon_concept.site_id,
          references: "Test reference.", toc_id: toc.origin_id, toc_site_id: toc.site_id, object_title: "Test Article",
          description: "Test text", data_type_id: DataType.text.id, language_id: Language.english.id,
          license_id: License.public_domain.id } 
        create_log_action_parameters(parameters_values_hash, create_data_object_peer_log)
        #call process entery
        create_data_object_peer_log.process_entry
        # create sync peer log for creating data_object_ref
        create_data_obj_ref_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_refs.id,
                                                       sync_object_type_id: SyncObjectType.data_object.id,
                                                       user_site_object_id: user.origin_id,
                                                       user_site_id: user.site_id,
                                                       sync_object_id: DataObject.last.origin_id, 
                                                       sync_object_site_id: DataObject.last.site_id)
        parameters_values_hash = { references: "Test reference." } 
        create_log_action_parameters(parameters_values_hash, create_data_obj_ref_peer_log)
        #call process entery
        create_data_obj_ref_peer_log.process_entry
        
        # create sync peer log for creating colection item
        create_collection_item_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id,
                                                          sync_object_type_id: SyncObjectType.collection_item.id,
                                                          user_site_object_id: user.origin_id,
                                                          user_site_id: user.site_id, 
                                                          sync_object_id: user.watch_collection.origin_id, 
                                                          sync_object_site_id: user.watch_collection.site_id)
        parameters_values_hash = { item_id: DataObject.last.origin_id, item_site_id: DataObject.last.site_id,
          collected_item_type: "DataObject", collected_item_name: "Test Article", add_item: 1 } 
        create_log_action_parameters(parameters_values_hash, create_collection_item_peer_log)
        #call process entery
        create_collection_item_peer_log.process_entry
      end
      let(:ref) { Ref.last }
      let(:data_obj) { DataObject.find_by_origin_id_and_site_id(10,10) }
      it "creates a reference" do
        expect(ref.full_reference).to eq("Test reference.") 
        expect(ref.user_submitted).to eq(true)
        expect(ref.visibility_id).to eq(Visibility.visible.id)
        expect(ref.published).to eq(1)
      end
      it "creates data object" do
        expect(data_obj.object_title).to eq("Test Article")
        expect(data_obj.description).to eq("Test text")
        expect(data_obj.license_id).to eq(License.public_domain.id)
      end
      it "creates user_data_object" do
        user_data_obj = UsersDataObject.find_by_user_id_and_data_object_id(user.id, data_obj.id)
        expect(user_data_obj.user_id).not_to be_nil 
        expect(user_data_obj.user_id).to eq(user.id)
        expect(data_obj.toc_items[0].id).to eq(TocItem.overview.id)
      end
      it "creates data_object_reference" do
        data_obj_ref = data_obj.refs[0]
        expect(data_obj_ref.id).to eq(ref.id) 
      end
      it "creates data_object_taxon_concept" do
        data_obj_taxon_concept = DataObjectsTaxonConcept.last
        expect(data_obj_taxon_concept.taxon_concept_id).to eq(taxon_concept.id)
        expect(data_obj_taxon_concept.data_object_id).to eq(data_obj.id)
      end
      it "creates colection_item" do
        col_item = CollectionItem.last
        expect(col_item.collected_item_type).to eq("DataObject")
        expect(col_item.name).to eq("Test Article")
        expect(col_item.collected_item_id).to eq(data_obj.id)
        expect(col_item.collection_id).to eq(user.watch_collection.id)
      end
      after(:all) do
        ref.destroy if ref
        data_object_taxon_concept = DataObjectsTaxonConcept.find_by_taxon_concept_id_and_data_object_id(taxon_concept.id, data_obj.id)
        data_object_taxon_concept.destroy if data_object_taxon_concept
        collection_item = CollectionItem.where("collection_id = ? and collected_item_id = ?", user.watch_collection.id, data_obj.id).first
        collection_item.destroy if collection_item
        data_obj.destroy if data_obj
      end
    end
    
    describe ".update_data_object" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        data_object.refs << Ref.new(full_reference: "Test reference", user_submitted: true, published: 1,
                                    visibility: Visibility.visible)
        # create sync peer log for creating ref                                         
        create_ref_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                                                    sync_object_type_id: SyncObjectType.ref.id,
                                                                    user_site_object_id: user.origin_id,
                                                                    user_site_id: user.site_id)
        parameters_values_hash = { reference: "Test reference." }
        create_log_action_parameters(parameters_values_hash, create_ref_peer_log)      
        #call process entery
        create_ref_peer_log.process_entry
        # create sync peer log for updationg data_object
        update_data_object_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                                                    sync_object_type_id: SyncObjectType.data_object.id,
                                                                    user_site_object_id: user.origin_id,
                                                                    user_site_id: user.site_id, 
                                                                    sync_object_id: data_object.origin_id, 
                                                                    sync_object_site_id: data_object.site_id)
        parameters_values_hash = { new_revision_origin_id: 3, new_revision_site_id: PEER_SITE_ID,
          references: "Test reference.", toc_id: toc.origin_id, toc_site_id: toc.site_id,
          object_title: "Test update", description: "Test text", data_type_id: DataType.text.id,
          language_id: Language.english.id, license_id: License.public_domain.id }
        create_log_action_parameters(parameters_values_hash, update_data_object_peer_log)   
        #call process entery
        update_data_object_peer_log.process_entry
      end
      after(:all) do
        DataObject.where(object_title: "Test update").each { |data| data.destroy if data }
        ref.destroy if ref
      end
      let(:ref) { Ref.last }
      let(:data_obj) { DataObject.last }
      it "creates reference" do
        expect(ref.full_reference).to eq("Test reference.") 
        expect(ref.user_submitted).to eq(true)
        expect(ref.visibility_id).to eq(Visibility.visible.id)
        expect(ref.published).to eq(1)
      end
      it "updates data object" do
        expect(data_obj.object_title).to eq("Test update")
        expect(data_obj.description).to eq("Test text")
        expect(data_obj.license_id).to eq(License.public_domain.id)
      end
      it "creates user_data_obj" do
        user_data_obj = UsersDataObject.last
        expect(user_data_obj.user_id).to eq(user.id)
        expect(data_obj.toc_items[0].id).to eq(TocItem.overview.id)
      end
      it "creates data_object_taxon_concept" do
        data_obj_taxon_concept = DataObjectsTaxonConcept.find(:first, conditions: "data_object_id = #{data_obj.id} and taxon_concept_id = #{taxon_concept.id}")
        expect(data_obj_taxon_concept).not_to be_nil
      end
    end
    
    describe "rate data object" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters","users_data_objects_ratings"])
        # create sync peer log for rating data object
        rate_data_object_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.rate.id,
                                                      sync_object_type_id: SyncObjectType.data_object.id,
                                                      user_site_object_id: user.origin_id,
                                                      user_site_id: user.site_id, 
                                                      sync_object_id: data_object.origin_id, 
                                                      sync_object_site_id: data_object.site_id)
        parameters_values_hash = { stars: 3 }
        create_log_action_parameters(parameters_values_hash, rate_data_object_peer_log)
        #call process entery
        rate_data_object_peer_log.process_entry
      end
      it "creates user_data_object_rating" do
        user_data_obj_rate = UsersDataObjectsRating.find_by_user_id_and_data_object_guid(user.id, data_object.guid)
        expect(user_data_obj_rate.user_id).to eq(user.id)
        expect(user_data_obj_rate.data_object_guid).to eq(data_object.guid)
        expect(user_data_obj_rate.rating).to eq(3)
      end
    end
  end
    
  describe "community synchronization" do
    let(:user) { User.first }
    describe ".create_community" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        #create sync_peer_log
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                        sync_object_type_id: SyncObjectType.community.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: 80, 
                                        sync_object_site_id: 2)
        parameters_values_hash = { community_name: "comm_name", community_description: "community_description",
          collection_origin_id: 12, collection_site_id: 2}
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        #call process entery
        sync_peer_log.process_entry
      end
      it "creates community" do
        comm = Community.find_by_origin_id_and_site_id(80,2)
        expect(comm).not_to be_nil
        expect(comm.name).to eq("comm_name")
        expect(comm.description).to eq("community_description")
      end
      after(:all) do
        Community.find_by_origin_id_and_site_id(80,2).destroy if Community.find_by_origin_id_and_site_id(80,2)
      end
    end
    
    describe ".add_collection_to_community" do
      let(:collection) { Collection.gen }
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        community = Community.gen
        community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
        community.add_member(user)
        community.members[0].update_column(:manager, 1)
        collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
        #create sync_peer_log
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id,
                                        sync_object_type_id: SyncObjectType.community.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: community.origin_id, 
                                        sync_object_site_id: community.site_id)
        parameters_values_hash = { collection_origin_id: collection.origin_id, collection_site_id: collection.site_id }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        #call process entery
        sync_peer_log.process_entry
      end
      it "adds collection to community" do
        expect(collection.communities.count).to eq(1)
      end
      after(:all) do
        Community.last.destroy if Community.last
        col = Collection.find_by_origin_id_and_site_id(collection.id, PEER_SITE_ID)
        col.destroy if col
      end
    end
    
    describe ".update_community" do
      let(:community) { Community.gen }
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
        #create sync_peer_log
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                        sync_object_type_id: SyncObjectType.community.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: community.origin_id, 
                                        sync_object_site_id: community.site_id)
        parameters_values_hash = { community_name: "new_name", community_description: "new_description",
          name_change: 1, description_change: 1 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        #call process entery
        sync_peer_log.process_entry
      end
      it "updates community" do
        new_community = Community.find(community.id)
        expect(new_community).not_to be_nil
        expect(new_community.name).to eq("new_name")
        expect(new_community.description).to eq("new_description")
      end
    end
    
    describe ".delete_community" do
      let(:community) { Community.gen }
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
        community.add_member(user)
        #create sync_peer_log
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                        sync_object_type_id: SyncObjectType.community.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: community.origin_id, 
                                        sync_object_site_id: community.site_id)
        #call process entery
        sync_peer_log.process_entry                               
      end
      it "deletes community" do
        unpublished_community = Community.find(community.id)
        expect(unpublished_community.published).to be_false
      end
      after(:all) do
        Community.find(community.id).destroy if Community.find(community.id)
      end
    end
    
    describe ".join_community" do
      let(:community) { Community.gen }
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID)
        #create sync_peer_log
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.join.id,
                                        sync_object_type_id: SyncObjectType.community.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: community.origin_id, 
                                        sync_object_site_id: community.site_id)
        @prev_members_count = community.members.count
        #call process entery
        sync_peer_log.process_entry
      end
      it "adds member to community" do
        comm = Community.find(community.id)
        comm.members.count.should == @prev_members_count + 1
      end
      after(:all) do
        Community.find(community.id).destroy if Community.find(community.id)
      end
    end
    
    describe ".leave_community" do
      let(:community) { Community.gen }
      let(:prev_members_count) { community.members.count }
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        community.update_attributes(origin_id: community.id, site_id: PEER_SITE_ID)
        community.add_member(user)
        #create sync_peer_log
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.leave.id,
                                        sync_object_type_id: SyncObjectType.community.id,
                                        user_site_object_id: user.origin_id,
                                        user_site_id: user.site_id, 
                                        sync_object_id: community.origin_id, 
                                        sync_object_site_id: community.site_id)
        @prev_members_count = community.members.count
        #call process entery
        sync_peer_log.process_entry
      end
      it "adds member to community" do
        comm = Community.find(community.id)
        comm.members.count.should == @prev_members_count - 1
      end
      after(:all) do
        Community.find(community.id).destroy if Community.find(community.id)
      end
    end
  end
    
  describe "user synchronization" do
    describe ".create_user" do
      subject(:user) { User.find_by_origin_id_and_site_id(100, 2) }
      
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: 100, sync_object_id: 100, user_site_id: 2,
                                          sync_object_site_id: 2)
          parameters_values_hash = { language: "en", validation_code: "89accf204c74d07fbdb1c2bad027946818142efb",
            remote_ip: "127.0.0.1", username: "user100", agreed_with_terms: 1, collection_site_id: 2,
            collection_origin_id: 10 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "creates new user" do
          expect(user).not_to be_nil          
        end
        it "has the correct 'username'" do
          expect(user.username).to eq("user100")
        end
        it "has the correct 'language_id'" do
          expect(user.language_id).to eq(Language.english.id)
        end
        it "has the correct 'validation_code'" do
          expect(user.validation_code).to eq("89accf204c74d07fbdb1c2bad027946818142efb")
        end
        it "has the correct 'remote_ip'" do
          expect(user.remote_ip).to eq("127.0.0.1")
        end
        it "has the correct 'origin_id'" do
          expect(user.origin_id).to eq(100)
        end
        it "has the correct 'site_id'" do
          expect(user.site_id).to eq(2)
        end
        it "has the correct 'agreed_with_terms'" do
          expect(user.agreed_with_terms).to eq(!(1.zero?))
        end
        it "hasn't sync 'email'" do
          expect(user.email).to be_nil
        end
        it "hasn't sync 'password'" do
          expect(user.hashed_password).to be_nil
        end
        it "creates a watch collection for new user" do
          expect(user.watch_collection).not_to be_nil
        end
        after(:all) do
          if user
            user.watch_collection.destroy if user.watch_collection
            user.destroy
          end
        end
      end
    end
    
    describe ".update_user" do
      subject(:user) { User.first }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: 2)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.origin_id, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
          parameters_values_hash = { username: "myusername", bio: "My bio", remote_ip: "127.0.0.2" }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          user.reload
        end
        it "updates 'username'" do
          expect(user.username).to eq("myusername")
        end
        it "updates 'bio'" do
          expect(user.bio).to eq("My bio")
        end
      end
      #TODO handle pull failures  
      context "failed update user not found" do
      end
    end
    
    describe ".activate_user" do
      subject(:user) { User.first }
      
      context "successful activate" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: 2, active: false)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.activate.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.origin_id, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
          sync_peer_log.process_entry
          user.reload
        end
        it "activates user" do        
          expect(user.active).to be_true
        end
        it "has the correct validation code" do        
          expect(user.validation_code).to be_nil
        end
      end
      #TODO handle pull failures  
      context "failed update user not found" do
      end
    end
    
    describe ".update_by_admin_user" do
      subject(:user) { User.first }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: 2)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update_by_admin.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.id+1, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
          parameters_values_hash = { username: "myusername", bio: "My bio", remote_ip: "127.0.0.2" }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          user.reload
        end
        it "updates 'username'" do
          expect(user.username).to eq("myusername")
        end
        it "updates 'bio'" do
          expect(user.bio).to eq("My bio")
        end
      end
      #TODO handle pull failures  
      context "failed update user not found" do
      end
    end
  end
   
  describe "comments synchronization" do
    describe ".create_comment" do
      let(:user) { User.first } 
      let(:comment_parent) { Collection.first }
      subject(:comment) { Comment.find_by_origin_id_and_site_id(20, PEER_SITE_ID) }
      
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: 20, user_site_id: user.site_id,
                                          sync_object_site_id: PEER_SITE_ID)
          parameters_values_hash = { parent_type: "Collection", comment_parent_origin_id: comment_parent.origin_id,
            comment_parent_site_id: comment_parent.site_id, body: "comment" }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "creates new comment" do
          expect(comment).not_to be_nil          
        end
        it "has the correct 'body'" do
          expect(comment.body).to eq("comment")
        end
        it "has the correct 'user_id'" do
          expect(comment.user_id).to eq(user.id)
        end
        it "has the correct 'parent_id'" do
          expect(comment.parent_id).to eq(comment_parent.id)
        end
        it "has the correct 'parent_type'" do
          expect( comment.parent_type).to eq("Collection")
        end
        after(:all) do
          comment.destroy if comment
        end
      end
      #TODO handle pull failures  
      context "failed creation: user not found" do
      end
    end
    
    describe ".update_comment" do
      let(:user) { User.first } 
      let(:comment_parent) { Collection.first }
      subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment") }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters_values_hash = { body: "new comment" }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          comment.reload
        end
        it "updates 'body'" do
          expect(comment.body).to eq("new comment")
        end
        after(:all) do
          comment.destroy if comment
        end
      end
      
      #TODO handle pull failures    
      context "failed update comment not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, text_last_updated_at: Time.now)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters_values_hash = { body: "new comment", updated_at: comment.text_last_updated_at - 2 } 
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          comment.reload
        end
        it "doesn't update 'body'" do
          expect(comment.body).to eq("comment")
        end
        after(:all) do
          comment.destroy if comment
        end
      end
    end
    
    describe ".delete_comment" do
      let(:user) { User.first }
      let(:comment_parent) { Collection.first }
      subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment") }
                                     
      context "successful deletion" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters_values_hash = { deleted: 1 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          comment.reload
        end
        it "deletes comment" do        
          expect(comment.deleted).to eq(1)
        end
        after(:all) do
          comment.destroy if comment
        end
      end
      #TODO handle pull failures  
      context "failed deletion: comment not found" do
      end
    end
     
    describe ".hide_comment" do
      let(:user) { User.first }
      let(:comment_parent) { Collection.first }
      subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment") }
                                     
      context "successful hide" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.hide.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          sync_peer_log.process_entry
          comment.reload
        end
        it "has correct 'visible_at'" do
          expect(comment.visible_at).to be_nil
        end
        after(:all) do
          comment.destroy if comment
        end
      end
      #TODO handle pull failures  
      context "failed hide: comment not found" do
      end
    end
    
    describe ".show_comment" do
      let(:user) { User.first }
      let(:comment_parent) { Collection.first }
      subject(:comment) { Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment",
                                     visible_at: nil) }
                                     
      context "successful show" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters_values_hash = { visible_at: Time.now }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          comment.reload
        end
        it "has correct 'visible_at'" do
          expect(comment.visible_at).not_to be_nil
        end
        after(:all) do
          comment.destroy if comment
        end
      end
      
      # handle synchronization conflict: last update wins
      context "failed show: elder show" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, visible_at: Time.now)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters_values_hash = { visible_at: comment.visible_at - 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          comment.reload
        end
        it "doesn't update 'visible_at'" do
          expect(comment.visible_at).not_to eq(comment.visible_at - 2)
        end
        after(:all) do
          comment.destroy if comment
        end
      end
      
      #TODO handle pull failures  
      context "failed show comment not found" do
      end
    end
  end

  describe "collections synchronization" do
    describe ".create_collection" do
      let(:user) { User.first } 
      let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", collection.id, user.id).first }
      subject(:collection) { Collection.find_by_origin_id_and_site_id(30, PEER_SITE_ID) }
        
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          create_collection_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.collection.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: 30, user_site_id: user.site_id,
                                                            sync_object_site_id: PEER_SITE_ID)
          parameters_values_hash = { name: "newcollection" }
          create_log_action_parameters(parameters_values_hash, create_collection_sync_peer_log)
          add_collection_item_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                              sync_object_type_id: SyncObjectType.collection_item.id,
                                                              user_site_object_id: user.origin_id, 
                                                              sync_object_id: 30, user_site_id: user.site_id,
                                                              sync_object_site_id: PEER_SITE_ID)
          parameters_values_hash = { item_id: user.id, item_site_id: user.site_id, collected_item_type: "User",
            collected_item_name: user.username, base_item: true }
          create_log_action_parameters(parameters_values_hash, add_collection_item_sync_peer_log)
          create_collection_sync_peer_log.process_entry
          add_collection_item_sync_peer_log.process_entry
        end
        it "creates new collection" do
          expect(collection).not_to be_nil          
        end
        it "has the correct 'name'" do
          expect(collection.name).to eq("newcollection")
        end
        it "has the correct 'user_id'" do
          expect(collection.users.first.id).to eq(user.id)
        end
        it "creates collection item for new collection" do
          expect(collection_item).not_to be_nil 
        end
        it "has correct 'collected item name'" do
          expect(collection_item.name).to eq("#{user.summary_name}")
        end
        it "has correct 'collected item type'" do
          expect(collection_item.collected_item_type).to eq("User")
        end
        it "has correct 'collected item id'" do
          expect(collection_item.collected_item_id).to eq(user.id)
        end
        it "has correct 'collection id'" do
          expect(collection_item.collection_id).to eq(collection.id)
        end
        after(:all) do
          collection.destroy if collection
          collection_item.destroy if collection_item
        end
      end
    end
    
    describe ".update_collection" do
      let(:user) { User.first }
      subject(:collection) { Collection.first }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       name: "collection")
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
          parameters_values_hash = { name: "newname", updated_at: collection.updated_at + 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          collection.reload
        end
        it "updates 'name'" do
          expect(collection.name).to eq("newname")
        end
      end
      
      #TODO handle pull failures    
      context "failed update: collection not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now, name: "collection")
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
          parameters_values_hash = { name: "newname", updated_at: collection.updated_at - 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          collection.reload
        end
        it "doesn't update 'name'" do
          expect(collection.name).to eq("collection")
        end
      end
    end
    
    describe ".delete_collection" do
      let(:user) { User.first }
      subject(:collection) { Collection.first }
      
      context "successful deletion" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
          sync_peer_log.process_entry
          collection.reload
        end
        it "deletes comment" do        
          expect(collection.published).to eq(false)
        end
        after(:all) do
          collection.update_attributes(published: true) if collection
        end
      end
      
      #TODO handle pull failures  
      context "failed deletion: collection not found" do
      end
    end
  end
  
  describe "collection items synchronization" do
    describe ".add_collection_item" do
      let(:user) { User.first } 
      subject(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", collection.id, user.id).first }
      let(:collection) { Collection.gen }
        
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_values_hash = { collected_item_type: "User", collected_item_name: user.summary_name,
            item_id: user.origin_id, item_site_id: user.site_id, add_item: true}
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "creates new collection item" do
          expect(collection_item).not_to be_nil          
        end
        it "has the correct 'collected item type'" do
          expect(collection_item.collected_item_type).to eq("User")
        end
        it "has correct 'collected item name'" do
          expect(collection_item.name).to eq("#{user.summary_name}")
        end
        it "has correct 'collected item id'" do
          expect(collection_item.collected_item_id).to eq(user.id)
        end
        it "has correct 'collection id'" do
          expect(collection_item.collection_id).to eq(collection.id)
        end
        after(:all) do
          collection_item.destroy if collection_item
          collection.destroy if collection
        end
      end
    end
    
    describe ".update_collection_item" do
      let(:user) { User.first } 
      subject(:collection_item) { CollectionItem.gen(name: "#{user.summary_name}", collected_item_type: "User",
                                                    collected_item_id: user.id, collection_id: collection.id,
                                                    annotation: "annotation") }
      let(:collection) { Collection.gen(name: "collection") }
      let(:ref) { Ref.find_by_full_reference("reference") }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          sync_peer_log_create_ref = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.ref.id,
                                                            user_site_object_id: user.origin_id, 
                                                            user_site_id: user.site_id)
          parameters_values_hash = { reference: "reference" }
          create_log_action_parameters(parameters_values_hash, sync_peer_log_create_ref)
          sync_peer_log_update_collection_item = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_values_hash = { collected_item_type: "User", item_id: user.origin_id, item_site_id: user.site_id,
            annotation: "new_annotation", updated_at: collection_item.updated_at + 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log_update_collection_item)
          sync_peer_log_add_refs_collection_item = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_refs.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_values_hash = { collected_item_type: "User", item_id: user.origin_id, item_site_id: user.site_id,
            references: "reference"}
          create_log_action_parameters(parameters_values_hash, sync_peer_log_add_refs_collection_item)
          sync_peer_log_create_ref.process_entry
          sync_peer_log_update_collection_item.process_entry
          sync_peer_log_add_refs_collection_item.process_entry
          collection_item.reload
        end
        it "creates new reference" do
          expect(ref).not_to be_nil
        end
        it "sets 'user_submitted' to 'true'" do
          expect(ref.user_submitted).to eq(true)
        end
        it "sets 'visibility_id' to 'visible'" do
          expect(ref.visibility_id).to eq(Visibility.visible.id)
        end
        it "sets 'published' to '1'" do
          expect(ref.published).to eq(1)
        end
        it "updates 'annotation'" do
          expect(collection_item.annotation).to eq("new_annotation")
        end
        it "adds new reference to collection item" do
          collection_items_refs = collection_item.refs
          expect(collection_items_refs[0].id).to eq(ref.id)
        end
        after(:all) do
          ref.destroy if ref
          collection_item.destroy if collection_item
          collection.destroy if collection
        end
      end
      
      #TODO handle pull failures    
      context "failed update: collection not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
          parameters_values_hash = { name: "newname", updated_at: collection.updated_at - 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          collection.reload
        end
        it "doesn't update 'annotation'" do
          expect(collection_item.annotation).to eq("annotation")
        end
        after(:all) do
          collection_item.destroy if collection_item
        end
      end
    end
  end
  
  describe "collection jobs synchronization" do
    describe ".create_collection_job 'copy'" do
      let(:user) { User.first }
      let(:collection) { Collection.first }
      let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", empty_collection.id, item.id).first }
      let(:item) { Collection.gen(name: "item") }
      let(:empty_collection) { Collection.gen(name: "empty_collection") }
      let(:collection_job) { CollectionJob.find_by_collection_id_and_user_id_and_command(collection.id,
                              user.id, "copy") }
                              
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          empty_collection.update_attributes(origin_id: empty_collection.id, site_id: PEER_SITE_ID)
          empty_collection.users = [user]
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                    collected_item_id: item.id, collection_id: collection.id)
          collection_job_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                         sync_object_type_id: SyncObjectType.collection_job.id,
                                                         user_site_object_id: user.origin_id, 
                                                         sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                         sync_object_site_id: collection.site_id)
          parameters_values_hash = { command: "copy", all_items: 1, overwrite: 0, item_count: 1, unique_job_id: "1#{PEER_SITE_ID}" }
          create_log_action_parameters(parameters_values_hash, collection_job_sync_peer_log)
          dummy_type_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                     sync_object_type_id: SyncObjectType.dummy_type.id,
                                                     user_site_object_id: user.origin_id, 
                                                     sync_object_id: empty_collection.origin_id, 
                                                     user_site_id: user.site_id,
                                                     sync_object_site_id: empty_collection.site_id)
          parameters_values_hash = { collected_item_type: "Collection", item_id: item.origin_id, 
            item_site_id: item.site_id, collected_item_name: item.summary_name, unique_job_id: "1#{PEER_SITE_ID}" }
          create_log_action_parameters(parameters_values_hash, dummy_type_sync_peer_log)
          collection_job_sync_peer_log.process_entry
        end
        it "creates new collection job" do
          expect(collection_job).not_to be_nil          
        end
        it "has the correct 'overwrite'" do
          expect(collection_job.overwrite).to eq(false)
        end
        it "has correct 'item_count'" do
          expect(collection_job.item_count).to eq(1)
        end
        it "has correct 'all_items'" do
          expect(collection_job.all_items).to eq(true)
        end
        it "has correct 'command'" do
          expect(collection_job.command).to eq("copy")
        end
        it "has creates 'collection_jobs_collection'" do
          job_collections = collection_job.collections
          expect(job_collections[0].id).to eq(empty_collection.id)
        end
        it "copies collection item to 'empty_collection'" do
          expect(collection_item).not_to be_nil
        end
        it "has correct 'name'" do
          expect(collection_item.name).to eq("item")
        end
        it "has correct 'collected_item_type'" do
          expect(collection_item.collected_item_type).to eq("Collection")
        end
        it "has correct 'collected_item_id'" do
          expect(collection_item.collected_item_id).to eq(item.id)
        end
         it "has correct 'collection_id'" do
          expect(collection_item.collection_id).to eq(empty_collection.id)
        end
        after(:all) do
          collection_job.destroy if collection_job
          empty_collection.destroy if empty_collection
          item.destroy if item
          collection_item.destroy if collection_item
          old_collection_item = CollectionItem.where("collection_id = ? and collected_item_id = ?", collection.id, item.id).first
          old_collection_item.destroy if old_collection_item
        end
      end
    end
    
    describe ".create_collection_job 'remove'" do
      let(:user) { User.first }
      let(:collection) { Collection.first }
      let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", collection.id, item.id).first }
      let(:item) { Collection.gen(name: "item") }
      let(:collection_job) { CollectionJob.find_by_collection_id_and_user_id_and_command(collection.id,
                              user.id, "remove") }
      
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                    collected_item_id: item.id, collection_id: collection.id)
          collection_job_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.collection_job.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_values_hash = { command: "remove", all_items: 1, overwrite: 0, item_count: 1,
            unique_job_id: "1#{PEER_SITE_ID}"}
          create_log_action_parameters(parameters_values_hash, collection_job_sync_peer_log)
          dummy_type_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.remove.id, 
                                                            sync_object_type_id: SyncObjectType.dummy_type.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, 
                                                            user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_values_hash = { collected_item_type: "Collection", item_id: item.origin_id, 
            item_site_id: item.site_id, unique_job_id: "1#{PEER_SITE_ID}" }
          create_log_action_parameters(parameters_values_hash, dummy_type_sync_peer_log)
          collection_job_sync_peer_log.process_entry
        end
        it "creates new collection job" do
          expect(collection_job).not_to be_nil          
        end
        it "has the correct 'overwrite'" do
          expect(collection_job.overwrite).to eq(false)
        end
        it "has correct 'item_count'" do
          expect(collection_job.item_count).to eq(1)
        end
        it "has correct 'all_items'" do
          expect(collection_job.all_items).to eq(true)
        end
        it "has correct 'command'" do
          expect(collection_job.command).to eq("remove")
        end
        it "removes collection item from 'collection'" do
          expect(collection_item).to be_nil
        end
        after(:all) do
          collection_job.destroy if collection_job
          item.destroy if item
          collection_item.destroy if collection_item
        end
      end
    end
  end
    
  describe "process pulling for translated content pages actions " do
    describe ".add_translation_content_page" do
      let(:user) { User.first }
      let(:content_page) { ContentPage.gen }
      subject(:translated_content_page) { TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, language.id) }
      let(:language) { Language.english }
      
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, sync_object_id: content_page.id)
          parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
            left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description", 
            active_translation: 1 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "adds new translation to content page" do
          expect(translated_content_page).not_to be_nil          
        end
        it "responds to 'language'" do
          expect(translated_content_page.language_id).to eq(language.id)
        end
        it "responds to 'title'" do
          expect(translated_content_page.title).to eq("title")
        end
        it "responds to 'main_content'" do
          expect(translated_content_page.main_content).to eq("main_content")
        end
        it "responds to 'left_content'" do
          expect(translated_content_page.left_content).to eq("left_content")
        end
        it "responds to 'meta_keywords'" do
          expect(translated_content_page.meta_keywords).to eq("meta_keywords")
        end
        it "responds to 'meta_description'" do
          expect(translated_content_page.meta_description).to eq("meta_description")
        end
        it "responds to 'active_translation'" do
          expect(translated_content_page.active_translation).to eq(1)
        end
        it "updates content page" do
          expect(content_page.last_update_user_id).to eq(user.id)
        end
        after(:all) do
          translated_content_page.destroy if translated_content_page
          content_page.destroy if content_page
        end
      end
      
      context "failed creation: content page not found" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 1000000)
          parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
            left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description",
            active_translation: 1 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "doesn't create translated content page" do
          expect(translated_content_page).to be_nil
        end
        after(:all) do
          translated_content_page.destroy if translated_content_page
          content_page.destroy if content_page
        end
      end
    end
    
    describe ".update_translated_content_page" do
      let(:content_page) { ContentPage.gen }
      subject(:translated_content_page) { TranslatedContentPage.gen(content_page: content_page, language: Language.english) } 
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user = User.first
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                        user_site_object_id: user.origin_id, sync_object_id: content_page.id)
          parameters_values_hash = { language_id: translated_content_page.language.id, title: "new title",
            main_content: "main_content", left_content: "left_content", meta_keywords: "meta_keywords",
            meta_description: "meta_description", active_translation: 1 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          translated_content_page.reload
        end
        it "updates title of translated content page" do
          expect(translated_content_page.title).to eq("new title")
        end
        it "updates main_content of translated content page" do
          expect(translated_content_page.main_content).to eq("main_content")
        end
        it "updates left_content of translated content page" do
          expect(translated_content_page.left_content).to eq("left_content")
        end
        it "updates meta_keywords of translated content page" do
          expect(translated_content_page.meta_keywords).to eq("meta_keywords")
        end
        it "updates meta_description of translated content page" do
          expect(translated_content_page.meta_description).to eq("meta_description")
        end
        after(:all) do
          translated_content_page.destroy if translated_content_page
          content_page.destroy if content_page
        end
      end
      
     #TODO handle pull failures  
      context "failed update: translated content page not found" do
      end
    end
    
    describe ".delete_translated_content_page" do
      let(:translated_content_page) { TranslatedContentPage.gen(content_page: content_page, language: Language.english, title: "Test Content Page") }
      subject(:content_page) { ContentPage.gen }
      let(:language) { Language.english }
      context "successful deletion" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user = User.first
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                        user_site_object_id: user.origin_id, sync_object_id: content_page.id)
          parameters_values_hash = { language_id: translated_content_page.language.id }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "deletes translated content page" do
          deleted_translated_content_page = TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, language.id)
          expect(deleted_translated_content_page).to be_nil
        end
        it "archives deleted translated content page" do
          archived_translated_content_page = TranslatedContentPageArchive.find_by_content_page_id_and_language_id(content_page.id, language.id)
          expect(archived_translated_content_page.title).to eq("Test Content Page")
        end
        after(:all) do
          translated_content_page.destroy if translated_content_page
          content_page.destroy if content_page
        end
      end
      
     #TODO handle pull failures  
      context "failed deletion translated content page not found" do
      end
    end
  end
  
  describe "content pages synchronization" do
    describe ".create_content_page" do
      let(:user) { User.first }
      subject(:content_page) { ContentPage.find_site_specific(100, PEER_SITE_ID) }
      let(:language) { Language.english }
      let(:translated_content_page) { TranslatedContentPage.find_by_content_page_id_and_language_id(content_page.id, language.id) }
      
      context "successful creation" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: 100, sync_object_site_id: PEER_SITE_ID)
          parameters_values_hash = { language_id: language.id, title: "title", main_content: "main_content",
            left_content: "left_content", meta_keywords: "meta_keywords", meta_description: "meta_description", 
            active_translation: 1, page_name: "page_name", active: "1", sort_order: "1" }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
        end
        it "creates new content page" do
          expect(content_page).not_to be_nil          
        end
        
        it "has correct 'active'" do
          expect(content_page.active).to eq(true)
        end
        
        it "has correct 'sort_order'" do
          expect(content_page.sort_order).to eq(1)
        end
        
        it "has correct 'page_name'" do
          expect(content_page.page_name).to eq("page_name")
        end
        
        it "has correct 'last_update_user_id'" do
          expect(content_page.last_update_user_id).to eq(user.id)
        end
        
        it "creates new translated content page" do
          expect(translated_content_page).not_to be_nil          
        end
        
        it "has correct 'title' for translated_content_page" do
          expect(translated_content_page.title).to eq("title")
        end
        
        it "correct 'main_content' for translated_content_page" do
          expect(translated_content_page.main_content).to eq("main_content")
        end
        
        it "has correct 'left_content' for translated_content_page" do
          expect(translated_content_page.left_content).to eq("left_content")
        end
        
        it "has correct 'meta_keywords' for translated_content_page" do
          expect(translated_content_page.meta_keywords).to eq("meta_keywords")
        end
        
        it "has correct 'meta_description' for translated_content_page" do
          expect(translated_content_page.meta_description).to eq("meta_description")
        end
        
        it "has correct 'active_translation' for translated_content_page" do
          expect(translated_content_page.active_translation).to eq(1)
        end
        
        after(:all) do
          content_page.destroy if content_page
          translated_content_page.destroy if translated_content_page
        end
      end
    end
    
    describe ".update_content_page" do
      let(:user) { User.first }
      subject(:content_page) { ContentPage.first }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          parameters_values_hash = { page_name: "page_name", active: "1", updated_at: content_page.updated_at + 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          content_page.reload
        end
                
        it "updates 'page_name'" do
          expect(content_page.page_name).to eq("page_name")
        end
      end
      
      context "failed update: elder update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID,
                                         page_name: "name")
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          parameters_values_hash = { page_name: "page_name", active: "1", updated_at: content_page.updated_at - 2 }
          create_log_action_parameters(parameters_values_hash, sync_peer_log)
          sync_peer_log.process_entry
          content_page.reload
        end
        
        it "doesn't update 'page_name'" do
          expect(content_page.page_name).to eq("name")
        end
      end
    end
    
    describe ".delete_content_page" do
      let(:user) { User.first }
      subject(:content_page) { ContentPage.gen }
      
      context "successful update" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
          @id = content_page.id
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          sync_peer_log.process_entry
        end
                
        it "deletes content page" do
          expect(ContentPage.find_site_specific(@id, PEER_SITE_ID)).to be_nil
        end
      end
    end
    
    describe ".swap_content_page 'move_down'" do
      let(:user) { User.first }
      subject(:content_page) { ContentPage.first }
      let(:lower_page) { ContentPage.gen(parent_content_page_id: "", page_name: "lower_page",
                                         active: "1", sort_order: 2) }
      context "successful swap" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, 
                                         sort_order: 1, swap_updated_at: Time.now)
          lower_page.update_attributes(origin_id: lower_page.id, site_id: PEER_SITE_ID,
                                       swap_updated_at: Time.now)
          content_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          content_page_parameters_values_hash = { content_page_sort_order: lower_page.sort_order,
                                                  updated_at: content_page.swap_updated_at + 2 }
          create_log_action_parameters(content_page_parameters_values_hash, content_page_sync_peer_log)
          
          swap_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: lower_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          swap_page_parameters_values_hash = { content_page_sort_order: content_page.sort_order,
                                               updated_at: lower_page.swap_updated_at + 2 }
          create_log_action_parameters(swap_page_parameters_values_hash, swap_page_sync_peer_log)
          
          content_page_sync_peer_log.process_entry
          content_page.reload
          swap_page_sync_peer_log.process_entry
          lower_page.reload
        end
                
        it "decreases sort order of content page" do
          expect(content_page.sort_order).to eq(2)
        end
        
        it "increases sort order of lower page" do
          expect(lower_page.sort_order).to eq(1)
        end
        
        after(:all) do
          lower_page.destroy if lower_page
        end
      end
    end
    
    describe ".swap_content_page 'move_up'" do
      let(:user) { User.first }
      subject(:content_page) { ContentPage.first }
      let(:upper_page) { ContentPage.gen(parent_content_page_id: "", page_name: "upper_page",
                                         active: "1", sort_order: 1) }
      context "successful swap" do
        before(:all) do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID, 
                                         sort_order: 2, swap_updated_at: Time.now)
          upper_page.update_attributes(origin_id: upper_page.id, site_id: PEER_SITE_ID,
                                       swap_updated_at: Time.now)
          content_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: content_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          content_page_parameters_values_hash = { content_page_sort_order: upper_page.sort_order,
                                                  updated_at: content_page.swap_updated_at + 2 }
          create_log_action_parameters(content_page_parameters_values_hash, content_page_sync_peer_log)
          
          swap_page_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.swap.id, sync_object_type_id: SyncObjectType.content_page.id,
                                        user_site_object_id: user.origin_id, user_site_id: PEER_SITE_ID,
                                        sync_object_id: upper_page.origin_id, sync_object_site_id: PEER_SITE_ID)
          swap_page_parameters_values_hash = { content_page_sort_order: content_page.sort_order,
                                               updated_at: upper_page.swap_updated_at + 2 }
          create_log_action_parameters(swap_page_parameters_values_hash, swap_page_sync_peer_log)
          
          content_page_sync_peer_log.process_entry
          content_page.reload
          swap_page_sync_peer_log.process_entry
          upper_page.reload
        end
                
        it "increases sort order of content page" do
          expect(content_page.sort_order).to eq(1)
        end
        
        it "decreases sort order of upper page" do
          expect(upper_page.sort_order).to eq(2)
        end
        
        after(:all) do
          upper_page.destroy if upper_page
        end
      end
    end
  end
  
 end
