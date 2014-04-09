require "spec_helper"

describe CollectionItemsController do

 describe "collection items actions" do
  before(:all) do
    # so this part of the before :all runs only once
    unless User.find_by_username('collections_scenario')
      truncate_all_tables
      load_scenario_with_caching(:collections)
    end
    @test_data = EOL::TestInfo.load('collections')
    @collection_item = @test_data[:collection].collection_items.last
    @collection_editor = @test_data[:collection].users.first
  end

  # This method is used when JS is disabled, otherwise items are updated through Collection controller
  describe "POST update" do
    it "should NOT update the item if user not logged in" do
      post :update, :id => @collection_item.id, :collection_item => {:annotation => "New Annotation"}
      expect(response).to redirect_to(login_url)
    end
    it "should update the item if user has permission to update" do
      getter = lambda{
        session[:user_id] = @collection_editor.id
        post :update, { :id => @collection_item.id, :collection_item => {:annotation => "New Annotation"} }
        @collection_item.reload
        unless @collection_item.annotation == "New Annotation" # What happened?  Seems rare... must be another error.
          debugger
          puts "Huh?"
        end
      }
      getter.should change(@collection_item, :annotation)
    end
  end
 end
  
  # add items to collections synchronization
  describe "mange collections items synchronization" do
    describe "add item to collections" do
      before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "collection_items", {})
        Activity.create_enumerated
        
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
        @first_collection = Collection.create(:name => "first_collection")
        @first_collection.users = [@current_user]
        @first_collection[:origin_id] = @first_collection.id
        @first_collection[:site_id] = PEER_SITE_ID
        @first_collection.save
        @second_collection = Collection.create(:name => "second_collection")
        @second_collection.users = [@current_user]
        @second_collection[:origin_id] = @second_collection.id
        @second_collection[:site_id] = PEER_SITE_ID
        @second_collection.save
        @item = Collection.create(:name => "collected_item")
        @item[:origin_id] = @item.id
        @item[:site_id] = PEER_SITE_ID
        @item.save
      end
      
      it 'should save updating collection paramters in synchronization tables' do
      
        post :create, :collection_item => {:collected_item_id => "#{@item.id}",
                      :collected_item_type => "Collection"}, 
                      :collection_id => ["#{@first_collection.id}","#{@second_collection.id}"]
         
          
        # created collections items   
        created_collection_item_for_first_collection =  CollectionItem.find(1)
        created_collection_item_for_first_collection.collected_item_type.should == "Collection"
        created_collection_item_for_first_collection.collection_id.should == @first_collection.id

        created_collection_item_for_second_collection =  CollectionItem.find(2)
        created_collection_item_for_second_collection.collected_item_type.should == "Collection"
        created_collection_item_for_second_collection.collection_id.should == @second_collection.id

        # check sync_object_type
        type = SyncObjectType.first
        type.should_not be_nil
        type.object_type.should == "Collection"

        # check sync_object_actions
        action = SyncObjectAction.first
        action.should_not be_nil
        action.object_action.should == "add_item"

        # check peer logs
        peer_log = SyncPeerLog.first
        peer_log.should_not be_nil
        peer_log.sync_object_action_id.should == action.id
        peer_log.sync_object_type_id.should == type.id
        peer_log.user_site_id .should == PEER_SITE_ID
        peer_log.user_site_object_id.should == @current_user.id
        peer_log.sync_object_id.should == @first_collection.id
        peer_log.sync_object_site_id.should == @first_collection.site_id

        # check log action parameters
        collection_origin_ids_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_id")
        collection_origin_ids_parameter[0][:value].should == "#{@item.origin_id}"
        collection_site_ids_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_site_id")
        collection_site_ids_parameter[0][:value].should == "#{@item.site_id}"
    
    
        collected_item_type_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collected_item_type")
        collected_item_type_parameter[0][:value].should == "Collection"
        collected_item_name_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collected_item_name")
        collected_item_name_parameter[0][:value].should == "#{@item.summary_name}"
        
         # check peer logs
        second_peer_log = SyncPeerLog.find(2)
        second_peer_log.should_not be_nil
        second_peer_log.sync_object_action_id.should == action.id
        second_peer_log.sync_object_type_id.should == type.id
        second_peer_log.user_site_id .should == PEER_SITE_ID
        second_peer_log.user_site_object_id.should == @current_user.id
        second_peer_log.sync_object_id.should == @second_collection.id
        second_peer_log.sync_object_site_id.should == @second_collection.site_id

        # check log action parameters
        collection_origin_ids_parameter = SyncLogActionParameter.where(:peer_log_id => second_peer_log.id, :parameter => "item_id")
        collection_origin_ids_parameter[0][:value].should == "#{@item.origin_id}"
        collection_site_ids_parameter = SyncLogActionParameter.where(:peer_log_id => second_peer_log.id, :parameter => "item_site_id")
        collection_site_ids_parameter[0][:value].should == "#{@item.site_id}"
    
    
        collected_item_type_parameter = SyncLogActionParameter.where(:peer_log_id => second_peer_log.id, :parameter => "collected_item_type")
        collected_item_type_parameter[0][:value].should == "Collection"
        collected_item_name_parameter = SyncLogActionParameter.where(:peer_log_id => second_peer_log.id, :parameter => "collected_item_name")
        collected_item_name_parameter[0][:value].should == "#{@item.summary_name}"
    
    
      end
    end
  end

end
