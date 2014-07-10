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
      post :update, id: @collection_item.id, collection_item: { annotation: "New Annotation" }
      expect(response).to redirect_to(login_url)
    end
    it "should update the item if user has permission to update" do
      getter = lambda{
        session[:user_id] = @collection_editor.id
        post :update, { id: @collection_item.id, collection_item: { annotation: "New Annotation" } }
        @collection_item.reload
        unless @collection_item.annotation == "New Annotation" # What happened?  Seems rare... must be another error.
          puts "Huh?"
        end
      }
      getter.should change(@collection_item, :annotation)
    end
  end
 end
 
 describe "mange collections items synchronization" do
   before(:all) do
      truncate_all_tables
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      Activity.create_enumerated
      Visibility.create_enumerated
    end
    
    describe "POST #create" do
        
      let(:first_collection_peer_log) {SyncPeerLog.first}
      let(:second_collection_peer_log) {SyncPeerLog.last}
      let(:user) {User.gen}
      let(:first_collection) {Collection.gen(name: "first_collection")}
      let(:second_collection) {Collection.gen(name: "second_collection")}
      let(:item) {Collection.gen(name: "item")}
      
      context "successful creation" do
        
        before do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          first_collection.update_attributes(origin_id: first_collection.id, site_id: PEER_SITE_ID)
          second_collection.update_attributes(origin_id: second_collection.id, site_id: PEER_SITE_ID)
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          post :create, collection_item: {collected_item_id: item.id,
                        collected_item_type: "Collection"}, 
                        collection_id: ["#{first_collection.id}","#{second_collection.id}"]
        end
        
        it "creates sync peer log for 'first collection'" do
          expect(first_collection_peer_log).not_to be_nil
        end
        
        it "has correct action for 'first collection'" do
          expect(first_collection_peer_log.sync_object_action_id).to eq(SyncObjectAction.add.id)
        end
        
        it "has correct type for 'first collection'" do
          expect(first_collection_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_item.id)
        end
        
        it "has correct 'user_site_id' for 'first collection'" do
          expect(first_collection_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id' for 'first collection'" do
          expect(first_collection_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        
        it "has correct 'object_site_id' for 'first collection'" do
          expect(first_collection_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id' for 'first collection'" do
          expect(first_collection_peer_log.sync_object_id).to eq(first_collection.origin_id)
        end
        
        it "creates sync log action parameter for 'item_id'" do
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: first_collection_peer_log.id, parameter: "item_id")
          expect(collection_site_ids_parameter[0][:value]).to eq("#{item.origin_id}")
        end
        
        it "creates sync log action parameter for 'item_site_id'" do
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: first_collection_peer_log.id, parameter: "item_site_id")
          expect(collection_origin_ids_parameter[0][:value]).to eq("#{item.site_id}")
        end
        
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: first_collection_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("Collection")
        end
        
        it "creates sync log action parameter for 'item_site_id'" do
          collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: first_collection_peer_log.id, parameter: "collected_item_name")
          expect(collected_item_name_parameter[0][:value]).to eq("#{item.summary_name}")
        end
        
        it "creates sync peer log for 'second collection'" do
          expect(second_collection_peer_log).not_to be_nil
        end
        
        it "has correct action for 'second collection'" do
          expect(second_collection_peer_log.sync_object_action_id).to eq(SyncObjectAction.add.id)
        end
        
        it "has correct type for 'second collection'" do
          expect(second_collection_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_item.id)
        end
        
        it "has correct 'user_site_id' for 'second collection'" do
          expect(second_collection_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id' for 'second collection'" do
          expect(second_collection_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        
        it "has correct 'object_site_id' for 'second collection'" do
          expect(second_collection_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id' for 'second collection'" do
          expect(second_collection_peer_log.sync_object_id).to eq(second_collection.origin_id)
        end
        
        it "creates sync log action parameter for 'item_id'" do
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: second_collection_peer_log.id, parameter: "item_id")
          expect(collection_site_ids_parameter[0][:value]).to eq("#{item.origin_id}")
        end
        
        it "creates sync log action parameter for 'item_site_id'" do
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: second_collection_peer_log.id, parameter: "item_site_id")
          expect(collection_origin_ids_parameter[0][:value]).to eq("#{item.site_id}")
        end
        
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: second_collection_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("Collection")
        end
        
        it "creates sync log action parameter for 'item_site_id'" do
          collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: second_collection_peer_log.id, parameter: "collected_item_name")
          expect(collected_item_name_parameter[0][:value]).to eq("#{item.summary_name}")
        end
        
      end
      
      context "failed creation: user should login" do
        before do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          first_collection.update_attributes(origin_id: first_collection.id, site_id: PEER_SITE_ID)
          second_collection.update_attributes(origin_id: second_collection.id, site_id: PEER_SITE_ID)
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          post :create, collection_item: {collected_item_id: item.id,
                        collected_item_type: "Collection"}, 
                        collection_id: ["#{first_collection.id}","#{second_collection.id}"]
        end
        
        it "doesn't create sync peer log for 'first collection'" do
          expect(first_collection_peer_log).to be_nil
        end
        it "doesn't create sync peer log for 'first collection'" do
          expect(second_collection_peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "PUT #update" do
        
      let(:create_ref_peer_log) {SyncPeerLog.find(2)}
      let(:update_collection_item_peer_log) {SyncPeerLog.first}
      let(:add_refs_to_collection_item_peer_log) {SyncPeerLog.last}
      let(:user) {User.gen}
      let(:collection) {Collection.gen(name: "collection")}
      let(:item) {Collection.gen(name: "item")}
      subject(:collection_item) {CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                   collected_item_id: item.id, collection_id: collection.id)}
      
      context "successful update" do
        
        before do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "refs", {})
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          put :update,  id: "#{collection_item.id}" , collection_item: {annotation: "annotation"}, 
                         references: "reference"
        end
        
        it "creates sync peer log for 'update_collection_item'" do
          expect(update_collection_item_peer_log).not_to be_nil
        end
        
        it "has correct action for 'update_collection_item'" do
          expect(update_collection_item_peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        
        it "has correct type for 'update_collection_item'" do
          expect(update_collection_item_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_item.id)
        end
        
        it "has correct 'user_site_id' for 'update_collection_item'" do
          expect(update_collection_item_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id' for 'update_collection_item'" do
          expect(update_collection_item_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        
        it "has correct 'object_site_id' for 'update_collection_item'" do
          expect(update_collection_item_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id' for 'update_collection_item'" do
          expect(update_collection_item_peer_log.sync_object_id).to eq(collection.origin_id)
        end
       
        it "creates sync log action parameter for 'item_id'" do
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: update_collection_item_peer_log.id, parameter: "item_id")
          expect(collection_site_ids_parameter[0][:value]).to eq("#{item.origin_id}")
        end
        
        it "creates sync log action parameter for 'item_site_id'" do
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: update_collection_item_peer_log.id, parameter: "item_site_id")
          expect(collection_origin_ids_parameter[0][:value]).to eq("#{item.site_id}")
        end
        
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: update_collection_item_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("Collection")
        end
        
        it "creates sync log action parameter for 'annotation'" do
          colllection_item_annotation_parameter = SyncLogActionParameter.where(peer_log_id: update_collection_item_peer_log.id, parameter: "annotation")
          expect(colllection_item_annotation_parameter[0][:value]).to eq("annotation")
        end
        
        it "creates sync peer log for 'create_ref'" do
          expect(create_ref_peer_log).not_to be_nil
        end
        
        it "has correct action for 'create_ref'" do
          expect(create_ref_peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        
        it "has correct type for 'create_ref'" do
          expect(create_ref_peer_log.sync_object_type_id).to eq(SyncObjectType.ref.id)
        end
        
        it "has correct 'user_site_id' for 'create_ref'" do
          expect(create_ref_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id' for 'create_ref'" do
          expect(create_ref_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        
        it "creates sync log action parameter for 'reference'" do
          full_reference_parameter = SyncLogActionParameter.where(peer_log_id: create_ref_peer_log.id, parameter: "reference")
          expect(full_reference_parameter[0][:value]).to eq("reference")
        end
        
        it "creates sync peer log for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log).not_to be_nil
        end
        
        it "has correct action for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log.sync_object_action_id).to eq(SyncObjectAction.add_refs.id)
        end
        
        it "has correct type for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_item.id)
        end
        
        it "has correct 'user_site_id' for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'user_id' for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        
        it "has correct 'object_site_id' for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        
        it "has correct 'object_id' for 'add_refs_to_collection_item'" do
          expect(add_refs_to_collection_item_peer_log.sync_object_id).to eq(collection.origin_id)
        end
        
        it "creates sync log action parameter for 'item_id'" do
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: add_refs_to_collection_item_peer_log.id, parameter: "item_id")
          expect(collection_site_ids_parameter[0][:value]).to eq("#{item.origin_id}")
        end
        
        it "creates sync log action parameter for 'item_site_id'" do
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: add_refs_to_collection_item_peer_log.id, parameter: "item_site_id")
          expect(collection_origin_ids_parameter[0][:value]).to eq("#{item.site_id}")
        end
        
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: add_refs_to_collection_item_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("Collection")
        end
        
        it "creates sync log action parameter for 'reference'" do
          collection_item_refs_parameter = SyncLogActionParameter.where(peer_log_id: add_refs_to_collection_item_peer_log.id, parameter: "references")
          expect(collection_item_refs_parameter[0][:value]).to eq("reference")
        end
      end
      
      context "failed update: user should login" do
        before do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "refs", {})
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          put :update,  id: "#{collection_item.id}" , collection_item: {annotation: "annotation"}, 
                         references: "reference"
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
