require "spec_helper"
  
describe CollectionJob do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_collection_job 'copy'" do
    let(:user) { User.first }
    let(:collection) { Collection.first }
    let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", empty_collection.id, item.id).first }
    let(:item) { Collection.gen(name: "item") }
    let(:empty_collection) { Collection.gen(name: "empty_collection") }
    let(:collection_job) { CollectionJob.find_by_collection_id_and_user_id_and_command(collection.id,
                            user.id, "copy") }
                            
    context "when successful creation" do
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
    
    context "when successful creation" do
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