require "spec_helper"

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
      #SpecialCollection.create(:name => "watch")
    end
    
    describe "common names" do
      describe ".add_common_name" do
        let(:user) {User.first}
        let(:hi) {Hierarchy.first}
        let(:he) {HierarchyEntry.first}
        let(:sr) {SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id)}
        before do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
          user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id,
                                  curator_approved: 1)
          tsr = TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id)
  
          relation  = SynonymRelation.find_by_translated(:label, 'common name')
  
          ar = AgentRole.gen()
          tar = TranslatedAgentRole.gen()
          tar.update_attributes(label: "Contributor", agent_role_id: ar.id, language_id: Language.first.id)
  
          Visibility.create(:id => 1)
          TranslatedVisibility.gen()
          TranslatedVisibility.first.update_attributes(label: "Visibile", language_id: Language.first.id, visibility_id: Visibility.first.id)
          
          hi.update_column(:label, 'Encyclopedia of Life Contributors')
  
          taxon_concept = TaxonConcept.first
          taxon_concept.update_column(:origin_id, taxon_concept.id)
          TaxonConceptPreferredEntry.create(:taxon_concept_id => taxon_concept.id, :hierarchy_entry_id => he.id)
        
          #create sync_peer_log
          @sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                           sync_object_type_id: SyncObjectType.common_name.id,
                                           user_site_object_id: user.origin_id,
                                           user_site_id: user.site_id, 
                                           sync_object_id: 80, 
                                           sync_object_site_id: PEER_SITE_ID)
          parameters = ["taxon_concept_site_id", "taxon_concept_origin_id", "string", "language"]
          values     = ["#{taxon_concept.site_id}", "#{taxon_concept.origin_id}", "add_name", "en"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: @sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
         TranslatedAgentRole.last.destroy
         TaxonConceptPreferredEntry.last.destroy
         TranslatedVisibility.last.destroy
         Name.find_by_string("add_name").destroy if Name.find_by_string("add_name")
         Synonym.last.destroy 
       end
      end
      
      describe ".update_common_name" do
        let(:user) {User.first}
        let(:hi) {Hierarchy.first}
        let(:he) {HierarchyEntry.first}
        let(:sr) {SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id)}
        let(:name) {Name.gen} 
        before :each do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
          user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id,
                                 curator_approved: 1)
          name.update_attributes(origin_id: name.id, site_id: PEER_SITE_ID)
  
          SynonymRelation.create(:id => 1)
  
          tsr = TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id)
  
          relation  = SynonymRelation.find_by_translated(:label, 'common name')
  
          ar = AgentRole.gen()
          tar = TranslatedAgentRole.gen()
          tar.update_attributes(label: "Contributor", agent_role_id: ar.id, language_id: Language.first.id)
  
          Visibility.create(:id => 1)
          TranslatedVisibility.gen()
          TranslatedVisibility.first.update_attributes(label: "Visibile", language_id: Language.first.id,
                                                       visibility_id: Visibility.first.id)
          hi = Hierarchy.gen()
          hi.update_column(:label, 'Encyclopedia of Life Contributors')
  
          taxon_concept = TaxonConcept.gen()
          taxon_concept.update_column(:origin_id, taxon_concept.id)
          
          TaxonConceptPreferredEntry.create(:taxon_concept_id => taxon_concept.id, :hierarchy_entry_id => HierarchyEntry.gen().id)
  
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
          parameters = ["language","taxon_concept_site_id", "taxon_concept_origin_id","string"]
          values     = ["#{Language.first.iso_639_1}", "#{taxon_concept.site_id}", "#{taxon_concept.origin_id}","#{name.string}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: @sync_peer_log, parameter: param,
                                             value: values[i])
          end
        end
        it "updates preferred column in synonym" do
          #call process entery
          @sync_peer_log.process_entry
          expect(Synonym.find_by_name_id(name.id).preferred).not_to eq(0)
        end
  
        it "ignores updates for deleted names" do
          truncate_table(ActiveRecord::Base.connection, "synonyms", {})
          #call process entery
          lambda{@sync_peer_log.process_entry}.should_not raise_exception
          expect(Synonym.all.count).to eq(0)
        end
        
        after(:each) do
          Name.last.destroy
          Synonym.last.destroy if Synonym.last
          TaxonConceptPreferredEntry.last.destroy
          TaxonConcept.last.destroy
          TaxonConceptName.last.destroy
          Hierarchy.last.destroy
          TranslatedAgentRole.last.destroy
          AgentRole.last.destroy
          TranslatedVisibility.last.destroy
        end
      end
      
      describe ".delete_common_name" do
        let(:user) {User.first}
        let(:hi) {Hierarchy.first}
        let(:he) {HierarchyEntry.first}
        let(:sr) {SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id)}
        let(:name) {Name.gen} 
        let(:tc) {TaxonConcept.first}
        let(:synonym) {Synonym.gen}
        
        before :all do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
          user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id,
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
          parameters = ["taxon_concept_site_id", "taxon_concept_origin_id"]
          values     = ["#{tc.site_id}", "#{tc.origin_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: @sync_peer_log, parameter: param,
                                             value: values[i])
          end 
          #call process entery
          @sync_peer_log.process_entry
        end
  
        it "should delete synonym and taxon_concept_name" do
          expect(TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(synonym.id, tc.id)).to be_nil
          expect(Synonym.find_by_id(synonym.id)).to be_nil
        end
        it "should ignore dalete actions for already deleted names" do
          truncate_table(ActiveRecord::Base.connection, "synonyms", {})
          #call process entery
          lambda{@sync_peer_log.process_entry}.should_not raise_exception
          expect(Synonym.all.count).to eq(0)
        end
        after(:all) do
          Synonym.last.destroy
          Name.last.destroy
          TaxonConceptName.last.destroy
        end
      end
      
      describe ".vet_common_name" do
        let(:user) {User.first}
        let(:hi) {Hierarchy.first}
        let(:he) {HierarchyEntry.first}
        let(:sr) {SynonymRelation.find(TranslatedSynonymRelation.find_by_label_and_language_id("common name", Language.first.id).synonym_relation_id)}
        let(:name) {Name.gen} 
        let(:tc) {TaxonConcept.first}
        let(:synonym) {Synonym.gen}
        
        before :all do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID)
          user.update_attributes(curator_level_id: CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id,
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
          parameters = ["vetted_view_order","taxon_concept_site_id", "taxon_concept_origin_id", "string"]
          values     = ["#{Vetted.first.view_order}","#{tc.site_id}", "#{tc.origin_id}", "#{name.string}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: @sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          @sync_peer_log.process_entry
        end
  
        it "should vet common name" do
          expect(TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(synonym.id, tc.id).vetted_id).to eq(1)
          expect(Synonym.find_by_id(synonym.id).vetted_id).to eq(1)
        end
        it "should ignore vet actions for already deleted names" do
          truncate_table(ActiveRecord::Base.connection, "synonyms", {})
          truncate_table(ActiveRecord::Base.connection, "taxon_concept_names", {})
          #call process entery
          lambda{@sync_peer_log.process_entry}.should_not raise_exception
          expect(Synonym.all.count).to eq(0)
        end
        after(:all) do
          Synonym.last.destroy
          Name.last.destroy
          TaxonConceptName.last.destroy
        end
      end
    end
    
    describe "data_object Synchronization" do
      
      let(:user) {User.first}
      let(:data_object) {DataObject.first}
      let(:he) {HierarchyEntry.first}
      let(:comment) {Comment.gen}
      let(:taxon_concept) {TaxonConcept.first}
      let(:toc) {TocItem.find(TocItem.overview.id)}
      
      before(:all) do
        user.update_attributes(curator_approved: 1, curator_level_id: 1)
        data_object.update_attributes(origin_id: data_object.id, site_id: PEER_SITE_ID)
        he.update_attributes(origin_id: he.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
        taxon_concept.update_attributes(origin_id: taxon_concept.id, site_id: PEER_SITE_ID)
        DataObjectsTaxonConcept.create(data_object_id: data_object.id, taxon_concept_id: taxon_concept.id)
        UsersDataObject.create(user_id: user.id, taxon_concept_id: taxon_concept.id, data_object_id: data_object.id, visibility_id: Visibility.invisible.id)
        toc.update_attributes(origin_id: toc.id, site_id: PEER_SITE_ID)
      end
        
      describe ".curate_association" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "curated_data_objects_hierarchy_entries", {})
          @cdoh = CuratedDataObjectsHierarchyEntry.create(:vetted_id => Vetted.first.id,
                         :visibility_id => Visibility.invisible.id, :user_id => user.id, 
                         :data_object_guid => data_object.guid, :hierarchy_entry_id => he.id,
                         :data_object_id => data_object.id) 
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.curate_associations.id,
                                          sync_object_type_id: SyncObjectType.data_object.id,
                                          user_site_object_id: user.origin_id,
                                          user_site_id: user.site_id, 
                                          sync_object_id: data_object.origin_id, 
                                          sync_object_site_id: data_object.site_id)
          parameters = ["language", "vetted_view_order", "curation_comment_origin_id", 
                        "curation_comment_site_id", "untrust_reasons", 
                        "visibility_label", "taxon_concept_origin_id", "taxon_concept_site_id","hierarchy_entry_origin_id", "hierarchy_entry_site_id"]
          values = ["en", "1", "#{comment.origin_id}", 
                    "#{comment.site_id}", "misidentified,", "Visible", 
                    "#{taxon_concept.origin_id}", "#{taxon_concept.site_id}", "#{he.origin_id}", "#{he.site_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "should curate association" do
          udo = UsersDataObject.find_by_user_id_and_data_object_id(user.id, data_object.id)
          expect(udo.visibility_id).to eq(Visibility.visible.id)
        end
      end
      
      describe ".add_association" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "curated_data_objects_hierarchy_entries", {})
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.save_association.id,
                                          sync_object_type_id: SyncObjectType.data_object.id,
                                          user_site_object_id: user.origin_id,
                                          user_site_id: user.site_id, 
                                          sync_object_id: data_object.origin_id, 
                                          sync_object_site_id: data_object.site_id)
          parameters = ["hierarchy_entry_origin_id", "hierarchy_entry_site_id"]
          values = ["#{he.origin_id}", "#{he.site_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "should add association" do
          cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(he.id, data_object.id)
          cdoh.should_not be_nil
        end
      end
      
      describe ".remove_association" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "curated_data_objects_hierarchy_entries", {})
          cdoh = CuratedDataObjectsHierarchyEntry.create(:vetted_id => Vetted.first.id,
                  :visibility_id => Visibility.visible.id, :user_id => user.id, 
                  :data_object_guid => data_object.guid, :hierarchy_entry_id => he.id,
                  :data_object_id => data_object.id) 
         
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.remove_association.id,
                                          sync_object_type_id: SyncObjectType.data_object.id,
                                          user_site_object_id: user.origin_id,
                                          user_site_id: user.site_id, 
                                          sync_object_id: data_object.origin_id, 
                                          sync_object_site_id: data_object.site_id)
          parameters = ["hierarchy_entry_origin_id", "hierarchy_entry_site_id"]
          values = ["#{he.origin_id}", "#{he.site_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "should remove association" do
          cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(he.id, data_object.id)
          cdoh.should be_nil
        end
      end
      
      describe ".create_data_object" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "refs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "data_objects_taxon_concepts", {})
          
          # create sync peer log for creating ref
          create_ref_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                                sync_object_type_id: SyncObjectType.ref.id,
                                                user_site_object_id: user.origin_id,
                                                user_site_id: user.site_id)
          create_ref_parameters = ["reference"]
          create_ref_values = [ "Test reference."]
          create_ref_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_ref_peer_log, parameter: param,
                                             value: create_ref_values[i])
          end
          #call process entery
          create_ref_peer_log.process_entry
          
          # create sync peer log for creating data_object
          create_data_object_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                                        sync_object_type_id: SyncObjectType.data_object.id,
                                                        user_site_object_id: user.origin_id,
                                                        user_site_id: user.site_id, 
                                                        sync_object_id: 10, 
                                                        sync_object_site_id: 10)
       
          create_data_object_parameters = ["taxon_concept_origin_id", "taxon_concept_site_id", 
            "references", "toc_id", "toc_site_id", "object_title", "description", "data_type_id",
            "language_id", "license_id"]
          create_data_object_values = ["#{taxon_concept.origin_id}", "#{taxon_concept.site_id}",
             "Test reference.", toc.origin_id, toc.site_id, "Test Article",
             "Test text", DataType.text.id.to_s, Language.english.id.to_s, License.public_domain.id.to_s]
          create_data_object_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_data_object_peer_log, parameter: param,
                                             value: create_data_object_values[i])
          end
          #call process entery
          create_data_object_peer_log.process_entry
          
          
          # create sync peer log for creating data_object_ref
          create_data_obj_ref_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_refs.id,
                                                         sync_object_type_id: SyncObjectType.data_object.id,
                                                         user_site_object_id: user.origin_id,
                                                         user_site_id: user.site_id,
                                                         sync_object_id: DataObject.last.origin_id, 
                                                         sync_object_site_id: DataObject.last.site_id)
          create_data_obj_ref_parameters = ["references"]
          create_data_obj_ref_values = ["Test reference."]
          create_data_obj_ref_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_data_obj_ref_peer_log, parameter: param,
                                             value: create_data_obj_ref_values[i])
          end
          #call process entery
          create_data_obj_ref_peer_log.process_entry
          
          # create sync peer log for creating colection item
          create_collection_item_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id,
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id,
                                                            user_site_id: user.site_id, 
                                                            sync_object_id: user.watch_collection.origin_id, 
                                                            sync_object_site_id: user.watch_collection.site_id)
          create_collection_item_parameters = ["item_id", "item_site_id", "collected_item_type", "collected_item_name", "add_item"]
          create_collection_item_values = ["#{DataObject.last.origin_id}", "#{DataObject.last.site_id}", "DataObject", "Test Article", "1"]
          create_collection_item_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_collection_item_peer_log, parameter: param,
                                             value: create_collection_item_values[i])
          end
          #call process entery
          create_collection_item_peer_log.process_entry
        end
        
        after(:all) do
          DataObject.find_by_origin_id_and_site_id(10,10).destroy
        end
        let(:ref) {Ref.last}
        let(:data_obj) {DataObject.find_by_origin_id_and_site_id(10,10)}
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
      end
      
      describe ".update_data_object" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "refs", {})
          truncate_table(ActiveRecord::Base.connection, "data_objects_refs", {})
#          data_object = taxon_concept.add_user_submitted_text(:user => user)
          data_object.refs << Ref.new(full_reference: "Test reference", user_submitted: true, published: 1,
                                      visibility: Visibility.visible)
          # create sync peer log for creating ref                                         
          create_ref_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                                                      sync_object_type_id: SyncObjectType.ref.id,
                                                                      user_site_object_id: user.origin_id,
                                                                      user_site_id: user.site_id)
          create_ref_parameters = ["reference"]
          create_ref_values = [ "Test reference."]
          create_ref_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_ref_peer_log, parameter: param,
                                           value: create_ref_values[i])
          end          
          #call process entery
          create_ref_peer_log.process_entry
          
          # create sync peer log for updationg data_object
          update_data_object_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                                                      sync_object_type_id: SyncObjectType.data_object.id,
                                                                      user_site_object_id: user.origin_id,
                                                                      user_site_id: user.site_id, 
                                                                      sync_object_id: data_object.origin_id, 
                                                                      sync_object_site_id: data_object.site_id)
          update_data_object_parameters = ["new_revision_origin_id", "new_revision_site_id",
            "references", "toc_id", "toc_site_id", "object_title", "description", "data_type_id",
            "language_id", "license_id"]
          update_data_object_values = [3, PEER_SITE_ID,
            "Test reference.", toc.origin_id, toc.site_id, "Test update",
            "Test text", DataType.text.id.to_s, Language.english.id.to_s, License.public_domain.id.to_s]
          update_data_object_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: update_data_object_peer_log, parameter: param,
                                             value: update_data_object_values[i])
          end 
          #call process entery
          update_data_object_peer_log.process_entry
        end
        after(:all) do
          DataObject.where(:object_title => "Test update").each {|data| data.destroy}
        end
        let(:ref) {Ref.last}
        let(:data_obj) {DataObject.last}
        
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
          data_obj_taxon_concept = DataObjectsTaxonConcept.find(:first, :conditions => "data_object_id = #{data_obj.id} and taxon_concept_id = #{taxon_concept.id}")
          expect(data_obj_taxon_concept).not_to be_nil
        end
      end
      
      describe "rate data object" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users_data_objects_ratings", {})
          # create sync peer log for rating data object
          rate_data_object_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.rate.id,
                                                        sync_object_type_id: SyncObjectType.data_object.id,
                                                        user_site_object_id: user.origin_id,
                                                        user_site_id: user.site_id, 
                                                        sync_object_id: data_object.origin_id, 
                                                        sync_object_site_id: data_object.site_id)
          rate_data_object_parameters = ["stars"]
          rate_data_object_values = [3]
          rate_data_object_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: rate_data_object_peer_log, parameter: param,
                                             value: rate_data_object_values[i])
          end
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
      let(:user) {User.first}
      describe ".create_community" do
        before(:all) do
          load_scenario_with_caching(:communities)
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          #create sync_peer_log
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                          sync_object_type_id: SyncObjectType.community.id,
                                          user_site_object_id: user.origin_id,
                                          user_site_id: user.site_id, 
                                          sync_object_id: 80, 
                                          sync_object_site_id: 2)
          parameters = ["community_name", "community_description", "collection_origin_id", "collection_site_id"]
          values = ["comm_name", "community_description", "12", "2"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
          Community.find_by_origin_id_and_site_id(80,2).destroy
        end
      end
      
      describe ".add_collection_to_community" do
        let(:collection) {Collection.gen}
        before(:all) do
          load_scenario_with_caching(:communities)
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
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
          parameters = ["collection_origin_id", "collection_site_id"]
          values = [collection.origin_id, collection.site_id]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "adds collection to community" do
          expect(collection.communities.count).to eq(1)
        end
        after(:all) do
          Community.last.destroy
          Collection.find_by_origin_id_and_site_id(origin_id: collection.id, site_id: PEER_SITE_ID).destroy
        end
      end
      
      describe ".update_community" do
        let(:community) {Community.gen}
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          SpecialCollection.create(:name => "watch")
          load_scenario_with_caching(:communities)
          
          community.update_attributes(name:"name", description: "desc", origin_id: community.id, site_id: PEER_SITE_ID)
          #create sync_peer_log
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                          sync_object_type_id: SyncObjectType.community.id,
                                          user_site_object_id: user.origin_id,
                                          user_site_id: user.site_id, 
                                          sync_object_id: community.origin_id, 
                                          sync_object_site_id: community.site_id)
          parameters = ["community_name", "community_description", "name_change", "description_change"]
          values = ["new_name", "new_description", "1", "1"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
        let(:community) {Community.gen}
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          load_scenario_with_caching(:communities)
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
          Community.find(community.id).destroy
        end
      end
      
      describe ".join_community" do
        let(:community) {Community.gen}
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          load_scenario_with_caching(:communities)
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
        it "should add member to community" do
          comm = Community.find(community.id)
          comm.members.count.should == @prev_members_count + 1
        end
        after(:all) do
          Community.find(community.id).destroy
        end
      end
      
      describe ".leave_community" do
        let(:community) {Community.gen}
        let(:prev_members_count) {community.members.count}
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          load_scenario_with_caching(:communities)
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
        it "should add member to community" do
          comm = Community.find(community.id)
          comm.members.count.should == @prev_members_count - 1
        end
        after(:all) do
          Community.find(community.id).destroy
        end
      end
    end
    
  describe "user synchronization" do
    describe ".create_user" do
        
      subject(:user) {User.first}
      
      context "successful creation" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: 100, sync_object_id: 100, user_site_id: 2,
                                          sync_object_site_id: 2)
                                        
          parameters = ["language", "validation_code", "remote_ip", "username", "agreed_with_terms",
                        "collection_site_id", "collection_origin_id"]
          values = ["en", "89accf204c74d07fbdb1c2bad027946818142efb", "127.0.0.1", "user100", 
                    1, "2", "10"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
      end
    end
    
    describe ".update_user" do
        
      subject(:user) {User.gen(username: "name")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: 2)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.origin_id, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
                                        
          parameters = ["username", "bio", "remote_ip"]
          values = ["myusername", "My bio", "127.0.0.2"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
        
      subject(:user) {User.gen(active: false)}
      
      context "successful activate" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: 2)
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
        
      subject(:user) {User.gen(username: "name")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: 2)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update_by_admin.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.id+1, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
          parameters = ["username", "bio", "remote_ip"]
          values = ["myusername", "My bio", "127.0.0.2"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
      
      let(:user) {User.gen} 
      let(:comment_parent) {Collection.gen(:name => "collection")}
      subject(:comment) {Comment.first}
      
      context "successful creation" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: 20, user_site_id: user.site_id,
                                          sync_object_site_id: PEER_SITE_ID)
           
          parameters = ["parent_type", "comment_parent_origin_id", "comment_parent_site_id", "body"]
          values = [ "Collection" , "#{comment_parent.origin_id}", "#{comment_parent.site_id}", "comment"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
      end
      #TODO handle pull failures  
      context "failed creation: user not found" do
      end
    end
    
    describe ".update_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
                                        
          parameters = ["body"]
          values = ["new comment"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "updates 'body'" do
          expect(comment.body).to eq("new comment")
        end
      end
      
      
      #TODO handle pull failures    
      context "failed update comment not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, last_updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
                                        
          parameters = ["body", "updated_at"]
          values = ["new comment", comment.last_updated_at - 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "doesn't update 'body'" do
          expect(comment.body).to eq("comment")
        end
      end
    end
    
    describe ".delete_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment")}
      
      context "successful deletion" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters = ["deleted"]
          values = ["1"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "deletes comment" do        
          expect(comment.deleted).to eq(1)
        end
      end
      #TODO handle pull failures  
      context "failed deletion: comment not found" do
      end
    end
     
    describe ".hide_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment")}
      
      context "successful hide" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
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
      end
      #TODO handle pull failures  
      context "failed hide: comment not found" do
      end
    end
    
    describe ".show_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment",
                                     visible_at: nil)}
      
      context "successful show" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters = ["visible_at"]
          values = [Time.now]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "has correct 'visible_at'" do
          expect(comment.visible_at).not_to be_nil
        end
      end
      
      # handle synchronization conflict: last update wins
      context "failed show: elder show" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, visible_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters = ["visible_at"]
          values = [comment.visible_at - 2]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "doesn't update 'visible_at'" do
          expect(comment.visible_at).not_to eq(comment.visible_at - 2)
        end
      end
      
      #TODO handle pull failures  
      context "failed show comment not found" do
      end
    end
  end

 
    
    describe "collections synchronization" do
    describe ".create_collection" do
      
      let(:user) {User.gen} 
      let(:collection_item) {CollectionItem.first}
      subject(:collection) {Collection.last}
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          
          create_collection_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.collection.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: 30, user_site_id: user.site_id,
                                                            sync_object_site_id: PEER_SITE_ID)
          parameters = ["name"]
          values = ["newcollection"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_collection_sync_peer_log, parameter: param,
                                             value: values[i])
          end
          
          add_collection_item_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                              sync_object_type_id: SyncObjectType.collection_item.id,
                                                              user_site_object_id: user.origin_id, 
                                                              sync_object_id: 30, user_site_id: user.site_id,
                                                              sync_object_site_id: PEER_SITE_ID)
          parameters_for_add_item = [ "item_id", "item_site_id", "collected_item_type", "collected_item_name", "base_item"]
          values_for_add_item = [ "#{user.id}", "#{user.site_id}", "User", "#{user.username}", true]

          parameters_for_add_item.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: add_collection_item_sync_peer_log, parameter: param,
                                             value: values_for_add_item[i])
          end
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
      end
    end
    
    describe ".update_collection" do
      let(:user) {User.gen(username: "name")}
      subject(:collection) {Collection.gen(name: "collection")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
                                        
          parameters = ["name", "updated_at"]
          values = ["newname", collection.updated_at + 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
                                        
          parameters = ["name", "updated_at"]
          values = ["newname", collection.updated_at - 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          collection.reload
        end
        
        it "doesn't update 'name'" do
          expect(collection.name).to eq("collection")
        end
      end
    end
    
    describe ".delete_collection" do
        
      let(:user) {User.gen(username: "name")}
      subject(:collection) {Collection.gen(name: "collection")}
      
      context "successful deletion" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
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
      end
      #TODO handle pull failures  
      context "failed deletion: collection not found" do
      end
    end
  end
  
  describe "collection items synchronization" do
    describe ".add_collection_item" do
      
      let(:user) {User.gen} 
      subject(:collection_item) {CollectionItem.first}
      let(:collection) {Collection.gen(name: "collection")}
      let(:item) {Collection.gen(name: "item")}
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters = ["collected_item_type", "collected_item_name" ,"item_id", "item_site_id", "add_item"]
          values = ["Collection", "item", "#{item.origin_id}", "#{item.site_id}", true]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
        end
        
        it "creates new collection item" do
          expect(collection_item).not_to be_nil          
        end
        
        it "has the correct 'collected item type'" do
          expect(collection_item.collected_item_type).to eq("Collection")
        end
  
        
        it "has correct 'collected item name'" do
          expect(collection_item.name).to eq("#{item.summary_name}")
        end
        
        it "has correct 'collected item id'" do
          expect(collection_item.collected_item_id).to eq(item.id)
        end
        
        it "has correct 'collection id'" do
          expect(collection_item.collection_id).to eq(collection.id)
        end
      end
    end
    
    describe ".update_collection_item" do
      let(:user) {User.gen} 
      subject(:collection_item) {CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                    collected_item_id: item.id, collection_id: collection.id)}
      let(:collection) {Collection.gen(name: "collection")}
      let(:item) {Collection.gen(name: "item")}
      let(:ref) {Ref.first}
      
      context "successful update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          
          sync_peer_log_create_ref = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.ref.id,
                                                            user_site_object_id: user.origin_id, 
                                                            user_site_id: user.site_id)
          parameters_create_ref = ["reference"]
          values_create_ref = ["reference"]

          parameters_create_ref.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log_create_ref, parameter: param,
                                             value: values_create_ref[i])
          end
          
          sync_peer_log_update_collection_item = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_update_collection_item = ["collected_item_type", "item_id", "item_site_id", "annotation", "updated_at"]
          values_update_collection_item = ["Collection", "#{item.origin_id}", "#{item.site_id}", "annotation", collection_item.updated_at + 2]

          parameters_update_collection_item.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log_update_collection_item, parameter: param,
                                             value: values_update_collection_item[i])
          end
          
          sync_peer_log_add_refs_collection_item = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_refs.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_add_refs_collection_item = ["collected_item_type", "item_id", "item_site_id", "references"]
          values_add_refs_collection_item = ["Collection", "#{item.origin_id}", "#{item.site_id}", "reference"]

          parameters_add_refs_collection_item.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log_add_refs_collection_item, parameter: param,
                                             value: values_add_refs_collection_item[i])
          end
          sync_peer_log_create_ref.process_entry
          sync_peer_log_update_collection_item.process_entry
          sync_peer_log_add_refs_collection_item.process_entry
          collection_item.reload
        end

        it "creates new reference" do
          expect(ref).not_to be_nil
        end
        
        it "sets 'full_reference' to 'reference'" do
          expect(ref.full_reference).to eq("reference")
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
          expect(collection_item.annotation).to eq("annotation")
        end
        
        it "adds new reference to collection item" do
          collection_items_refs = collection_item.refs
          expect(collection_items_refs[0].id).to eq(ref.id)
        end
      end
      
      
      #TODO handle pull failures    
      context "failed update: collection not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
                                        
          parameters = ["name", "updated_at"]
          values = ["newname", collection.updated_at - 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          collection.reload
        end
        
        it "doesn't update 'name'" do
          expect(collection.name).to eq("collection")
        end
      end
    end
  end
  
  describe "collection jobs synchronization" do
    describe ".create_collection_job 'copy'" do
      
      let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", empty_collection.id, item.id).first }
      let(:item) {Collection.gen(name: "item")}
      let(:empty_collection) { Collection.gen(name: "empty_collection") }
      let(:collection_job) { CollectionJob.first }
      
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user = User.gen
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection = Collection.gen(name: "collection")
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
          collection_job_parameters = ["command", "all_items" ,"overwrite", "item_count", "unique_job_id"]
          collection_job_values = ["copy", "1", "0", "1", "1#{PEER_SITE_ID}"]

          collection_job_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: collection_job_sync_peer_log, parameter: param,
                                             value: collection_job_values[i])
          end
          
          dummy_type_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                            sync_object_type_id: SyncObjectType.dummy_type.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: empty_collection.origin_id, 
                                                            user_site_id: user.site_id,
                                                            sync_object_site_id: empty_collection.site_id)

          dummy_type_parameters = ["collected_item_type", "item_id", "item_site_id", "collected_item_name", "unique_job_id"]
          dummy_type_job_values = ["Collection", "#{item.origin_id}", "#{item.site_id}", "#{item.summary_name}", "1#{PEER_SITE_ID}"]

          dummy_type_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: dummy_type_sync_peer_log, parameter: param,
                                             value: dummy_type_job_values[i])
          end
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
      end
    end
    
    describe ".create_collection_job 'remove'" do
      
      let(:collection_item) { CollectionItem.first }
      let(:item) {Collection.gen(name: "item")}
      let(:collection) { Collection.gen(name: "collection") }
      let(:collection_job) { CollectionJob.first }
      
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user = User.gen
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
          collection_job_parameters = ["command", "all_items" ,"overwrite", "item_count", "unique_job_id"]
          collection_job_values = ["remove", "1", "0", "1", "1#{PEER_SITE_ID}"]

          collection_job_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: collection_job_sync_peer_log, parameter: param,
                                             value: collection_job_values[i])
          end
          
          dummy_type_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.remove.id, 
                                                            sync_object_type_id: SyncObjectType.dummy_type.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, 
                                                            user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)

          dummy_type_parameters = ["collected_item_type", "item_id", "item_site_id", "unique_job_id"]
          dummy_type_job_values = ["Collection", "#{item.origin_id}", "#{item.site_id}", "1#{PEER_SITE_ID}"]

          dummy_type_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: dummy_type_sync_peer_log, parameter: param,
                                             value: dummy_type_job_values[i])
          end
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
      end
    end
  end

    # test admin content pages actions synchronization
    describe "process pulling for content pages actions " do
      describe "pulling create content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
          @admin = User.gen
          @admin.grant_admin
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'create')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = 80
          @peer_log.sync_object_site_id = 2
          @peer_log.save
          
          #create sync_action_parameters
          parameters = ["parent_content_page_id", "page_name", "active", "language_id", "title", "main_content", "left_content", "meta_keywords", "meta_description", "active_translation"]
          values = ["", "test5", "1", "#{Language.first.id}", "test5", "<p>hello5</p>\r\n", "", "", "", "1"]
  
          for i in 0..parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = parameters[i]
            lap.value = values[i]
            lap.save
          end
          #call process entery
          @peer_log.process_entry
        end
  
        it "should create content_page" do
          ContentPage.count.should == 1
          content_page = ContentPage.first
          content_page.page_name.should == "test5"
          content_page.active.should == true
          TranslatedContentPage.count.should == 1
          translated_content_page = TranslatedContentPage.first
          translated_content_page.title.should == "test5"
          translated_content_page.language_id.should == Language.first.id
        end
      end
      
      describe "pulling delete content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
          @admin = User.gen
          @admin.grant_admin
          content_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"test5", "active"=>"1")
          content_page.update_column(:origin_id, content_page.id)
          content_page.update_column(:site_id, PEER_SITE_ID)
          translated_content_page = TranslatedContentPage.create({"content_page_id" => "#{content_page.id}" , 
                                                 "language_id"=>"#{Language.first.id}", 
                                                 "title"=>"test5", 
                                                 "main_content"=>"<p>hello5</p>\r\n", 
                                                 "left_content"=>"", 
                                                 "meta_keywords"=>"",
                                                 "meta_description"=>"", 
                                                 "active_translation"=>"1"})
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'delete')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event (random number)
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('delete').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = content_page.origin_id
          @peer_log.sync_object_site_id = content_page.site_id
          @peer_log.save
          
          #call process entery
          @peer_log.process_entry
        end
  
        it "should delete content_page" do
          ContentPage.count.should == 0
          TranslatedContentPage.count.should == 0
        end
      end
      
      describe "pulling move content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          @admin = User.gen
          @admin.grant_admin
          
          upper_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"upper_page", "active"=>"1", "sort_order" => 1)
          upper_page.update_column(:origin_id, upper_page.id)
          upper_page.update_column(:site_id, PEER_SITE_ID)
          lower_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"lower_page", "active"=>"1", "sort_order" => 2)
          lower_page.update_column(:origin_id, lower_page.id)
          lower_page.update_column(:site_id, PEER_SITE_ID)
          
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'swap')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event (random number)
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('swap').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = lower_page.origin_id
          @peer_log.sync_object_site_id = lower_page.site_id
          @peer_log.save
          
          #create sync_action_parameters
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = "sort_order"
          lap.value = upper_page.sort_order
          lap.save
          
          #call process entery
          @peer_log.process_entry
          
          @peer_log1 = SyncPeerLog.new
          @peer_log1.sync_event_id = 4 #pull event (random number)
          @peer_log1.user_site_id = @admin.site_id
          @peer_log1.user_site_object_id = @admin.origin_id
          @peer_log1.action_taken_at = Time.now
          @peer_log1.sync_object_action_id = SyncObjectAction.find_by_object_action('swap').id
          @peer_log1.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log1.sync_object_id = upper_page.origin_id
          @peer_log1.sync_object_site_id = upper_page.site_id
          @peer_log1.save
                    
          lap1 = SyncLogActionParameter.new
          lap1.peer_log_id = @peer_log1.id
          lap1.param_object_type_id = nil
          lap1.param_object_id = nil
          lap1.param_object_site_id = nil
          lap1.parameter = "sort_order"
          lap1.value = upper_page.sort_order + 1
          lap1.save
          
          #call process entery
          @peer_log1.process_entry
        end
  
        it "should update sort_order of content_page" do
          ContentPage.count.should == 2
          content_page = ContentPage.first
          content_page.page_name.should == "upper_page"
          content_page.active.should == true
          content_page.sort_order.should == 2
        end
      end
      
      describe "pulling update content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          @admin = User.gen
          @admin.grant_admin
          content_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"old_name", "active"=>"1")
          content_page.update_column(:origin_id, content_page.id)
          content_page.update_column(:site_id, PEER_SITE_ID)
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'update')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event (random number)
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = content_page.origin_id
          @peer_log.sync_object_site_id = content_page.site_id
          @peer_log.save
          
          #create sync_action_parameters
          parameters = ["parent_content_page_id", "page_name", "active"]
          values = ["", "updated_name", "1"]
  
          for i in 0..parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = parameters[i]
            lap.value = values[i]
            lap.save
          end
          #call process entery
          @peer_log.process_entry
        end
  
        it "should update page name of content_page" do
          ContentPage.count.should == 1
          content_page = ContentPage.first
          content_page.page_name.should == "updated_name"
          content_page.active.should == true
        end
      end
    end    
    
    describe "process pulling for translated content pages actions " do
      describe ".add_translation_content_page" do
        
        let(:user) {User.gen}
        let(:content_page) {ContentPage.gen}
        subject(:translated_content_page) {TranslatedContentPage.first}
        let(:language) {Language.english}
        
        context "successful creation" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
                                          
            parameters = ["language_id", "title", "main_content", "left_content",
                          "meta_keywords", "meta_description", "active_translation"]
            values = ["#{language.id}" , "title", "main_content", "left_content",
                      "meta_keywords", "meta_description", "1"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
          end
          
          it "new translation will be added to content page" do
            expect(translated_content_page).not_to be_nil          
          end
          
          it "translated content page should respond to 'language'" do
            expect(translated_content_page.language_id).to eq(language.id)
          end
        
          it "translated content page should respond to 'title'" do
            expect(translated_content_page.title).to eq("title")
          end
          
          it "translated content page should respond to 'main_content'" do
            expect(translated_content_page.main_content).to eq("main_content")
          end
          
          it "translated content page should respond to 'left_content'" do
            expect(translated_content_page.left_content).to eq("left_content")
          end
          
          it "translated content page should respond to 'meta_keywords'" do
            expect(translated_content_page.meta_keywords).to eq("meta_keywords")
          end
          
          it "translated content page should respond to 'meta_description'" do
            expect(translated_content_page.meta_description).to eq("meta_description")
          end
          
          it "translated content page should respond to 'active_translation'" do
            expect(translated_content_page.active_translation).to eq(1)
          end
          
          it "update content page" do
            expect(content_page.last_update_user_id).to eq(user.id)
          end
        end
        
        context "failed creation: content page not found" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
            
            parameters = ["language_id", "title", "main_content", "left_content",
                          "meta_keywords", "meta_description", "active_translation"]
            values = ["#{language.id}" , "title", "main_content", "left_content",
                      "meta_keywords", "meta_description", "1"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
          end
          
          it "doesn't create translated content page" do
            expect(translated_content_page).to be_nil
          end
        end
       end
      
      describe ".update_translated_content_page" do
        
        let(:content_page) {ContentPage.gen}
        subject(:translated_content_page) {TranslatedContentPage.gen(content_page: content_page, language: Language.english)} 
        
        context "successful update" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user = User.gen
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
            
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
                                          
            parameters = ["language_id", "title", "main_content", "left_content",
                          "meta_keywords", "meta_description", "active_translation"]
            values = ["#{translated_content_page.language.id}" , "new title", "main_content", "left_content",
                      "meta_keywords", "meta_description", "1"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
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
        end
       #TODO handle pull failures  
        context "failed update: translated content page not found" do
        end
       end
      end
      
      describe ".delete_translated_content_page" do
        
        context "successful deletion" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user = User.gen
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            content_page = ContentPage.gen
            content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
            translated_content_page = TranslatedContentPage.gen(content_page: content_page, language: Language.english)
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
            
            parameters = ["language_id"]
            values = ["#{translated_content_page.language.id}"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
          end
        
          it "delets translated content page" do
            expect(TranslatedContentPage.all).to be_blank
          end
          
          it "archives deleted translated content page" do
            expect(TranslatedContentPageArchive.first.title).to eq("Test Content Page")
          end
        end
       #TODO handle pull failures  
        context "failed deletion translated content page not found" do
        end
       end
    
  end
