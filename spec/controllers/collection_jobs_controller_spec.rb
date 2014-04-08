require "spec_helper"


describe CollectionJobsController do
  
  describe "sync events" do
     before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "data_objects", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "collection_items", {})
        truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
        truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
        SpecialCollection.create_enumerated

             
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
        @collection = Collection.create(:name => "collection")
        @collection[:origin_id] = @collection.id
        @collection[:site_id] = PEER_SITE_ID
        @collection.save
        @collection.users = [@current_user]
        # empty collection
        @empty_collection = Collection.create(:name => "empty_collection")
        @empty_collection[:origin_id] = @empty_collection.id
        @empty_collection[:site_id] = PEER_SITE_ID
        @empty_collection.save
        @empty_collection.users = [@current_user]
        
        @item = Collection.create(:name => "collected_item")
        @item[:origin_id] = @item.id
        @item[:site_id] = PEER_SITE_ID
        @item.save
        @collection_item = CollectionItem.create(:name => "#{@item.name}", :collected_item_type => "Collection",
                              :collected_item_id => @item.id, :collection_id => @collection.id)
        
      end
    describe "sync copy collection" do
      it 'should save creating copy from collection paramters in synchronization tables' do

         post :create, {:collection_job => {:collection_id => @collection.id, 
                       :command => "copy", :all_items => true, :overwrite => 0,
                       :collection_ids => ["0", @empty_collection]}, :collection_name => "copy_data_col", 
                       :commit => "Copy", :scope => "all_items"}
                       
        
                       
           # new copy collection
          new_collection =  Collection.find(5)
          new_collection.name.should == 'copy_data_col'          
          user_new_collection = new_collection.users.first
          user_new_collection.id.should == @current_user.id
          
          # testing coping collection items
           new_collection_item = CollectionItem.find(2)
          new_collection_item.name.should == @item.name
          new_collection_item.collected_item_type.should == "Collection"
          new_collection_item.collected_item_id.should == "#{@item.id}".to_i
          new_collection_item.collection_id.should == "#{@empty_collection.id}".to_i
          
          new_collection_item = CollectionItem.find(3)
          new_collection_item.name.should == @item.name
          new_collection_item.collected_item_type.should == "Collection"
          new_collection_item.collected_item_id.should == "#{@item.id}".to_i
          new_collection_item.collection_id.should == "#{new_collection.id}".to_i
          
         
          
          # test for creating collection job(copy)
          collection_job = CollectionJob.first
          collection_job.command.should == "copy"
          collection_job.user_id.should == @current_user.id
          collection_job.collection_id.should == @collection.id
          collection_job.all_items.should == true
          
           job_collections = collection_job.collections
           job_collections.count.should == 2
           job_collections[0].id.should == @empty_collection.id
           job_collections[1].id.should == new_collection.id

  
          # check sync_object_type
          type = SyncObjectType.first
          type.should_not be_nil
          type.object_type.should == "Collection"
  
          # check sync_object_actions
          action = SyncObjectAction.first
          action.should_not be_nil
          action.object_action.should == "copy"
  
          # check peer logs
          peer_log = SyncPeerLog.first
          peer_log.should_not be_nil
          peer_log.sync_object_action_id.should == action.id
          peer_log.sync_object_type_id.should == type.id
          peer_log.user_site_id .should == PEER_SITE_ID
          peer_log.user_site_object_id.should == @current_user.id
          peer_log.sync_object_id.should == @collection.id
          peer_log.sync_object_site_id.should == PEER_SITE_ID
  
          # check log action parameters
          # parameters for new collection 
          collectionid_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "new_collection_origin_id")
          collectionid_parameter[0][:value].should == "#{new_collection.origin_id}"
          collectionname_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "new_collection_name")
          collectionname_parameter[0][:value].should == "#{new_collection.name}"
          
          # parameters for collection job
          collection_job_command_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "command")
          collection_job_command_parameter[0][:value].should == "copy"
          item_count_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_count")
          item_count_parameter[0][:value].should == "2"
          all_items_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "all_items")
          all_items_parameter[0][:value].should == "1"    
          overwrite_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "overwrite")
          overwrite_parameter[0][:value].should == "0"
      
          copied_collections_origin_ids_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "copied_collections_origin_ids")
          copied_collections_origin_ids_parameter[0][:value].should == "#{@empty_collection.id},"
          copied_collections_site_ids_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "copied_collections_site_ids")
          copied_collections_site_ids_parameter[0][:value].should == "1,"
          
          # parameters for collected items
          items_ids_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_origin_ids")
          items_ids_parameter[0][:value].should == "#{@item.origin_id},"
          items_sites__parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_site_ids")
          items_sites__parameter[0][:value].should == "1,"
          items_names_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_names")
          items_names_parameter[0][:value].should == "#{@item.name},"
          items_types__parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_types")
          items_types__parameter[0][:value].should == "Collection,"

      end
    end
    
     describe "sync remove items from collection" do
      it 'should save removing items from collection paramters in synchronization tables' do
         post :create, {:collection_job => {:collection_id => @collection.id, 
                       :command => "remove", :all_items => true}, :scope => "all_items"}
       
          # testing removing collection items 
          CollectionItem.all.should == []
   
          # test for creating collection job(remove)
          collection_job = CollectionJob.first
          collection_job.command.should == "remove"
          collection_job.user_id.should == @current_user.id
          collection_job.collection_id.should == @collection.id
          collection_job.all_items.should == true
        
          # check sync_object_type
          type = SyncObjectType.first
          type.should_not be_nil
          type.object_type.should == "Collection"
  
          # check sync_object_actions
          action = SyncObjectAction.first
          action.should_not be_nil
          action.object_action.should == "remove_item"
  
          # check peer logs
          peer_log = SyncPeerLog.first
          peer_log.should_not be_nil
          peer_log.sync_object_action_id.should == action.id
          peer_log.sync_object_type_id.should == type.id
          peer_log.user_site_id .should == PEER_SITE_ID
          peer_log.user_site_object_id.should == @current_user.id
          peer_log.sync_object_id.should == @collection.id
          peer_log.sync_object_site_id.should == PEER_SITE_ID
  
          # check log action parameters         
          
          # parameters for collection job
          collection_job_command_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "command")
          collection_job_command_parameter[0][:value].should == "remove"
          item_count_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_count")
          item_count_parameter[0][:value].should == "1"
          all_items_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "all_items")
          all_items_parameter[0][:value].should == "1"    
          overwrite_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "overwrite")
          overwrite_parameter[0][:value].should == "0"
                  
          # parameters for collected items
          items_ids_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_origin_ids")
          items_ids_parameter[0][:value].should == "#{@item.origin_id},"
          items_sites__parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_site_ids")
          items_sites__parameter[0][:value].should == "1,"
          items_names_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_names")
          items_names_parameter[0][:value].should == "#{@item.name},"
          items_types__parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_items_types")
          items_types__parameter[0][:value].should == "Collection,"

      end
    end
  end
end
