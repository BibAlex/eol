require "spec_helper"

describe CollectionJobsController do
  
  describe "synchronization" do
    before(:all) do
      truncate_all_tables
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
    end
    
    describe "POST #create 'copy'" do
      let(:collection_job_peer_log) { SyncPeerLog.first }
      let(:add_collection_item_peer_log) { SyncPeerLog.last }
      let(:user) { User.gen }
      let(:collection) { Collection.gen(name: "base_collection") }
      let(:empty_collection) { Collection.gen(name: "empty_collection") }
      let(:item) { Collection.gen(name: "item") }
      subject(:collection_job) { CollectionJob.first }
      context "successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","collection_jobs",
            "collection_items_collection_jobs","collection_jobs_collections","users",
            "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          empty_collection.update_attributes(origin_id: empty_collection.id, site_id: PEER_SITE_ID)
          empty_collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                             collected_item_id: item.id, collection_id: collection.id)
          
          post :create, { collection_job: { collection_id: collection.id, 
                         command: "copy", all_items: true, overwrite: 0,
                         collection_ids: [empty_collection] }, 
                         commit: "Copy", scope: "all_items" }
        end
        it "creates sync peer log for 'collection job'" do
          expect(collection_job_peer_log).not_to be_nil
        end
        it "has correct action for 'collection job'" do
          expect(collection_job_peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type for 'collection job'" do
          expect(collection_job_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_job.id)
        end
        it "has correct 'user_site_id' for 'collection job'" do
          expect(collection_job_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id' for 'collection job'" do
          expect(collection_job_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id' for 'collection job'" do
          expect(collection_job_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id' for 'collection job'" do
          expect(collection_job_peer_log.sync_object_id).to eq(collection.origin_id)
        end
        it "creates sync log action parameter for 'command'" do
          collection_job_command_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "command")
          expect(collection_job_command_parameter[0][:value]).to eq("copy")
        end
        it "creates sync log action parameter for 'item_count'" do
          item_count_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "item_count")
          expect(item_count_parameter[0][:value]).to eq("1")
        end
        it "creates sync log action parameter for 'all_items'" do
          all_items_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "all_items")
          expect(all_items_parameter[0][:value]).to eq("1")
        end
        it "creates sync log action parameter for 'overwrite'" do
          overwrite_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "overwrite")
          expect(overwrite_parameter[0][:value]).to eq("0")
        end
        it "creates sync log action parameter for 'unique_job_id'" do
          unique_job_id_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "unique_job_id")
          expect(unique_job_id_parameter[0][:value]).to eq("#{collection_job.id}#{PEER_SITE_ID}")
        end
        it "creates sync peer log for 'add collection item'" do
          expect(add_collection_item_peer_log).not_to be_nil
        end
        it "has correct action for 'add collection item'" do
          expect(add_collection_item_peer_log.sync_object_action_id).to eq(SyncObjectAction.add.id)
        end
        it "has correct type for 'add collection item'" do
          expect(add_collection_item_peer_log.sync_object_type_id).to eq(SyncObjectType.dummy_type.id)
        end
        it "has correct 'user_site_id' for 'add collection item'" do
          expect(add_collection_item_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id' for 'add collection item'" do
          expect(add_collection_item_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id' for 'add collection item'" do
          expect(add_collection_item_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id' for 'add collection item'" do
          expect(add_collection_item_peer_log.sync_object_id).to eq(empty_collection.origin_id)
        end
        it "creates sync log action parameter for 'item_id'" do
          collected_item_id_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "item_id")
          expect(collected_item_id_parameter[0][:value]).to eq("#{item.origin_id}")
        end
        it "creates sync log action parameter for 'item_site_id'" do
          collected_item_site_id_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "item_site_id")
          expect(collected_item_site_id_parameter[0][:value]).to eq("#{item.site_id}")
        end
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("Collection")
        end
        it "creates sync log action parameter for 'unique_job_id'" do
          unique_job_id_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "unique_job_id")
          expect(unique_job_id_parameter[0][:value]).to eq("#{collection_job.id}#{PEER_SITE_ID}")
        end
        it "creates sync log action parameter for 'item_site_id'" do
          collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "collected_item_name")
          expect(collected_item_name_parameter[0][:value]).to eq("#{item.summary_name}")
        end
      end
      
      context "failed creation: user should login" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","collection_jobs",
                      "collection_items_collection_jobs","collection_jobs_collections","users",
                      "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          empty_collection.update_attributes(origin_id: empty_collection.id, site_id: PEER_SITE_ID)
          empty_collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                             collected_item_id: item.id, collection_id: collection.id)
          expect { post :create, { collection_job: { collection_id: collection.id, 
                                command: "copy", all_items: true, overwrite: 0,
                                collection_ids: [empty_collection] }, collection_name: "collection", 
                                commit: "Copy", scope: "all_items" } }.to raise_error(EOL::Exceptions::MustBeLoggedIn)
        end
        it "doesn't create sync peer logs" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    
    describe "POST #create 'remove'" do
      let(:collection_job_peer_log) { SyncPeerLog.first }
      let(:remove_collection_item_peer_log) { SyncPeerLog.last }
      let(:user) { User.gen }
      let(:collection) { Collection.gen(name: "base_collection") }
      let(:item) { Collection.gen(name: "item") }
      subject(:collection_job) { CollectionJob.first }
        
      context "successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","collection_jobs",
                           "collection_items_collection_jobs","collection_jobs_collections","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                             collected_item_id: item.id, collection_id: collection.id)
          post :create, { collection_job: { collection_id: collection.id, 
                         command: "remove", all_items: true }, scope: "all_items" }
        end
        it "creates sync peer log for 'collection job'" do
          expect(collection_job_peer_log).not_to be_nil
        end
        it "has correct action for 'collection job'" do
          expect(collection_job_peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type for 'collection job'" do
          expect(collection_job_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_job.id)
        end
        it "has correct 'user_site_id' for 'collection job'" do
          expect(collection_job_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id' for 'collection job'" do
          expect(collection_job_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id' for 'collection job'" do
          expect(collection_job_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id' for 'collection job'" do
          expect(collection_job_peer_log.sync_object_id).to eq(collection.origin_id)
        end
        it "creates sync log action parameter for 'command'" do
          collection_job_command_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "command")
          expect(collection_job_command_parameter[0][:value]).to eq("remove")
        end
        it "creates sync log action parameter for 'item_count'" do
          item_count_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "item_count")
          expect(item_count_parameter[0][:value]).to eq("1")
        end
        it "creates sync log action parameter for 'all_items'" do
          all_items_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "all_items")
          expect(all_items_parameter[0][:value]).to eq("1")
        end
        it "creates sync log action parameter for 'overwrite'" do
          overwrite_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "overwrite")
          expect(overwrite_parameter[0][:value]).to eq("0")
        end
        it "creates sync log action parameter for 'unique_job_id'" do
          unique_job_id_parameter = SyncLogActionParameter.where(peer_log_id: collection_job_peer_log.id, parameter: "unique_job_id")
          expect(unique_job_id_parameter[0][:value]).to eq("#{collection_job.id}#{PEER_SITE_ID}")
        end
        it "creates sync peer log for 'remove collection item'" do
          expect(remove_collection_item_peer_log).not_to be_nil
        end
        it "has correct action for 'remove collection item'" do
          expect(remove_collection_item_peer_log.sync_object_action_id).to eq(SyncObjectAction.remove.id)
        end
        it "has correct type for 'remove collection item'" do
          expect(remove_collection_item_peer_log.sync_object_type_id).to eq(SyncObjectType.dummy_type.id)
        end
        it "has correct 'user_site_id' for 'remove collection item'" do
          expect(remove_collection_item_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id' for 'remove collection item'" do
          expect(remove_collection_item_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id' for 'remove collection item'" do
          expect(remove_collection_item_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id' for 'remove collection item'" do
          expect(remove_collection_item_peer_log.sync_object_id).to eq(collection.origin_id)
        end
        it "creates sync log action parameter for 'item_id'" do
          collected_item_id_parameter = SyncLogActionParameter.where(peer_log_id: remove_collection_item_peer_log.id, parameter: "item_id")
          expect(collected_item_id_parameter[0][:value]).to eq("#{item.origin_id}")
        end
        it "creates sync log action parameter for 'item_site_id'" do
          collected_item_site_id_parameter = SyncLogActionParameter.where(peer_log_id: remove_collection_item_peer_log.id, parameter: "item_site_id")
          expect(collected_item_site_id_parameter[0][:value]).to eq("#{item.site_id}")
        end
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: remove_collection_item_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("Collection")
        end
        it "creates sync log action parameter for 'unique_job_id'" do
          unique_job_id_parameter = SyncLogActionParameter.where(peer_log_id: remove_collection_item_peer_log.id, parameter: "unique_job_id")
          expect(unique_job_id_parameter[0][:value]).to eq("#{collection_job.id}#{PEER_SITE_ID}")
        end
      end
      
      context "failed creation: user should login" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","collection_jobs",
                           "collection_items_collection_jobs","collection_jobs_collections","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                             collected_item_id: item.id, collection_id: collection.id)
          expect { post :create, { collection_job: { collection_id: collection.id, 
                                command: "remove", all_items: true }, scope: "all_items" } }.to raise_error(EOL::Exceptions::MustBeLoggedIn)
        end
        it "doesn't create sync peer logs" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
  end
end