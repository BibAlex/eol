require "spec_helper"
  
describe Collection do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
 
  describe ".create_collection" do
    let(:user) { User.first } 
    let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", collection.id, user.id).first }
    subject(:collection) { Collection.find_by_origin_id_and_site_id(30, PEER_SITE_ID) }
      
    context "when successful creation" do
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
    
    context "when successful update" do
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
    context "when update fails because the collection isn't found" do
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
    
    context "when successful deletion" do
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
    context "when deletion fails because the collection isn't found" do
    end
  end
end