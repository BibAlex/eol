require "spec_helper"


describe CollectionJobsController do
  
  describe "sync events" do
     before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "collection_items", {})
        truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
        truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
        truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
        SpecialCollection.create_enumerated
            
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
        @collection = Collection.create(name: "collection")
        @collection[:origin_id] = @collection.id
        @collection[:site_id] = PEER_SITE_ID
        @collection.save
        @collection.users = [@current_user]
        # empty collection
        @empty_collection = Collection.create(name: "empty_collection")
        @empty_collection[:origin_id] = @empty_collection.id
        @empty_collection[:site_id] = PEER_SITE_ID
        @empty_collection.save
        @empty_collection.users = [@current_user]
        
        @item = Collection.create(name: "collected_item")
        @item[:origin_id] = @item.id
        @item[:site_id] = PEER_SITE_ID
        @item.save
        @collection_item = CollectionItem.create(name: "#{@item.name}", collected_item_type: "Collection",
                              collected_item_id: @item.id, collection_id: @collection.id)
        
      end
    describe "sync copy collection" do
      it 'should save creating copy from collection paramters in synchronization tables' do

         post :create, {collection_job: {collection_id: @collection.id, 
                       command: "copy", all_items: true, overwrite: 0,
                       collection_ids: ["0", @empty_collection]}, collection_name: "copy_data_col", 
                       commit: "Copy", scope: "all_items"}
                        
           # new created collection
          new_collection =  Collection.find(5)
          new_collection.name.should == 'copy_data_col'          
          user_new_collection = new_collection.users.first
          user_new_collection.id.should == @current_user.id
          
          # testing coping collection items
          CollectionItem.find(:first, conditions: "collection_id = #{@empty_collection.id} and collected_item_id =  #{@item.id}").should_not be nil
          CollectionItem.find(:first, conditions: "collection_id = #{new_collection.id} and collected_item_id =  #{@item.id}").should_not be nil
    
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
          create_action = SyncObjectAction.first
          create_action.should_not be_nil
          create_action.object_action.should == "create"
          
          # check sync_object_actions
          create_job_action = SyncObjectAction.find(2)
          create_job_action.should_not be_nil
          create_job_action.object_action.should == "create_job"
          
          # check sync_object_actions
          add_item_action = SyncObjectAction.find(3)
          add_item_action.should_not be_nil
          add_item_action.object_action.should == "add_item"
  
          # check peer log creating new collection
          peer_log = SyncPeerLog.first
          peer_log.should_not be_nil
          peer_log.sync_object_action_id.should == create_action.id
          peer_log.sync_object_type_id.should == type.id
          peer_log.user_site_id .should == PEER_SITE_ID
          peer_log.user_site_object_id.should == @current_user.id
          peer_log.sync_object_id.should == new_collection.origin_id
          peer_log.sync_object_site_id.should == PEER_SITE_ID
  
          # check log action parameters
          # parameters for new collection
          collectionname_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "name")
          collectionname_parameter[0][:value].should == "#{new_collection.name}"
          
          # check peer log creating  collection job
          second_peer_log = SyncPeerLog.find(2)
          second_peer_log.should_not be_nil
          second_peer_log.sync_object_action_id.should == create_job_action.id
          second_peer_log.sync_object_type_id.should == type.id
          second_peer_log.user_site_id .should == PEER_SITE_ID
          second_peer_log.user_site_object_id.should == @current_user.id
          second_peer_log.sync_object_id.should == @collection.origin_id
          second_peer_log.sync_object_site_id.should == PEER_SITE_ID
          
          
          # parameters for collection job
          collection_job_command_parameter = SyncLogActionParameter.where(peer_log_id: second_peer_log.id, parameter: "command")
          collection_job_command_parameter[0][:value].should == "copy"
          item_count_parameter = SyncLogActionParameter.where(peer_log_id: second_peer_log.id, parameter: "item_count")
          item_count_parameter[0][:value].should == "2"
          all_items_parameter = SyncLogActionParameter.where(peer_log_id: second_peer_log.id, parameter: "all_items")
          all_items_parameter[0][:value].should == "1"    
          overwrite_parameter = SyncLogActionParameter.where(peer_log_id: second_peer_log.id, parameter: "overwrite")
          overwrite_parameter[0][:value].should == "0"
      
          copied_collections_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: second_peer_log.id, parameter: "copied_collections_origin_ids")
          copied_collections_origin_ids_parameter[0][:value].should == "#{@empty_collection.origin_id},#{new_collection.origin_id},"
          copied_collections_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: second_peer_log.id, parameter: "copied_collections_site_ids")
          copied_collections_site_ids_parameter[0][:value].should == "1,1,"
          
          
            # check peer logs
          add_item_peer_log = SyncPeerLog.find(3)
          add_item_peer_log.should_not be_nil
          add_item_peer_log.sync_object_action_id.should == add_item_action.id
          add_item_peer_log.sync_object_type_id.should == type.id
          add_item_peer_log.user_site_id .should == PEER_SITE_ID
          add_item_peer_log.user_site_object_id.should == @current_user.id
          add_item_peer_log.sync_object_id.should == @empty_collection.id
          add_item_peer_log.sync_object_site_id.should == @empty_collection.site_id
  
          # check log action parameters
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: add_item_peer_log.id, parameter: "item_id")
          collection_origin_ids_parameter[0][:value].should == "#{@item.origin_id}"
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: add_item_peer_log.id, parameter: "item_site_id")
          collection_site_ids_parameter[0][:value].should == "#{@item.site_id}"
      
      
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: add_item_peer_log.id, parameter: "collected_item_type")
          collected_item_type_parameter[0][:value].should == "Collection"
          collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: add_item_peer_log.id, parameter: "collected_item_name")
          collected_item_name_parameter[0][:value].should == "#{@item.summary_name}"
       
                   
            # check peer log for adding item
          second_add_item_peer_log = SyncPeerLog.find(4)
          second_add_item_peer_log.should_not be_nil
          second_add_item_peer_log.sync_object_action_id.should == add_item_action.id
          second_add_item_peer_log.sync_object_type_id.should == type.id
          second_add_item_peer_log.user_site_id .should == PEER_SITE_ID
          second_add_item_peer_log.user_site_object_id.should == @current_user.id
          second_add_item_peer_log.sync_object_id.should == new_collection.id
          second_add_item_peer_log.sync_object_site_id.should == new_collection.site_id
  
          # check log action parameters
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: second_add_item_peer_log.id, parameter: "item_id")
          collection_origin_ids_parameter[0][:value].should == "#{@item.origin_id}"
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: second_add_item_peer_log.id, parameter: "item_site_id")
          collection_site_ids_parameter[0][:value].should == "#{@item.site_id}"
      
      
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: second_add_item_peer_log.id, parameter: "collected_item_type")
          collected_item_type_parameter[0][:value].should == "Collection"
          collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: second_add_item_peer_log.id, parameter: "collected_item_name")
          collected_item_name_parameter[0][:value].should == "#{@item.summary_name}"
       
      end
    end
    
     describe "sync remove items from collection" do
      it 'should save removing items from collection paramters in synchronization tables' do
         post :create, {collection_job: {collection_id: @collection.id, 
                       command: "remove", all_items: true}, scope: "all_items"}
       
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
          create_job_action = SyncObjectAction.first
          create_job_action.should_not be_nil
          create_job_action.object_action.should == "create_job"
          
          # check sync_object_actions
          remove_item_action = SyncObjectAction.find(2)
          remove_item_action.should_not be_nil
          remove_item_action.object_action.should == "remove_item"
  
          # check peer log for creating remove job
          peer_log = SyncPeerLog.first
          peer_log.should_not be_nil
          peer_log.sync_object_action_id.should == create_job_action.id
          peer_log.sync_object_type_id.should == type.id
          peer_log.user_site_id .should == PEER_SITE_ID
          peer_log.user_site_object_id.should == @current_user.id
          peer_log.sync_object_id.should == @collection.id
          peer_log.sync_object_site_id.should == PEER_SITE_ID
  
          # check log action parameters         
          
          # parameters for collection job
          collection_job_command_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "command")
          collection_job_command_parameter[0][:value].should == "remove"
          item_count_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "item_count")
          item_count_parameter[0][:value].should == "1"
          all_items_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "all_items")
          all_items_parameter[0][:value].should == "1"    
          overwrite_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "overwrite")
          overwrite_parameter[0][:value].should == "0"
                  
          # parameters for collected items
          items_ids_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_items_origin_ids")
          items_ids_parameter[0][:value].should == "#{@item.origin_id},"
          items_sites__parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_items_site_ids")
          items_sites__parameter[0][:value].should == "1,"
          items_names_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_items_names")
          items_names_parameter[0][:value].should == "#{@item.name},"
          items_types__parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_items_types")
          items_types__parameter[0][:value].should == "Collection,"
          
            # check peer log for removing item
          remove_item_peer_log = SyncPeerLog.find(2)
          remove_item_peer_log.should_not be_nil
          remove_item_peer_log.sync_object_action_id.should == remove_item_action.id
          remove_item_peer_log.sync_object_type_id.should == type.id
          remove_item_peer_log.user_site_id .should == PEER_SITE_ID
          remove_item_peer_log.user_site_object_id.should == @current_user.id
          remove_item_peer_log.sync_object_id.should == @collection.id
          remove_item_peer_log.sync_object_site_id.should == @collection.site_id
  
          # check log action parameters
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: remove_item_peer_log.id, parameter: "item_id")
          collection_origin_ids_parameter[0][:value].should == "#{@item.origin_id}"
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: remove_item_peer_log.id, parameter: "item_site_id")
          collection_site_ids_parameter[0][:value].should == "#{@item.site_id}"
      
      
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: remove_item_peer_log.id, parameter: "collected_item_type")
          collected_item_type_parameter[0][:value].should == "Collection"
                

      end
    end
  end
end
