require "spec_helper"
  
describe DataObject do
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
    user_data_object = UsersDataObject.create(user_id: user.id,
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
      expect(udo.visible?).to be_true
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
      expect(ref.visible?).to be_true
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
      expect(ref.visible?).to be_true
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
  after(:all) do
    user_data_object.destroy if user_data_object
  end
end