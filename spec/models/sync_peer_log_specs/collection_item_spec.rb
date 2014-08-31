require "spec_helper"
  
describe SyncPeerLog do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".add_collection_item" do
    let(:user) { User.first } 
    subject(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", collection.id, user.id).first }
    let(:collection) { Collection.gen }
      
    context "when successful creation" do
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
    
    context "when successful update" do
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
        expect(ref.visible?).to be_true
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
    context "when update fails because the collection isn't found" do
    end
    
    # handle synchronization conflict: last update wins
    context "when update fails because there is a newer update" do
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