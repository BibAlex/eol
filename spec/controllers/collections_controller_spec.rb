require "spec_helper"


describe CollectionsController do

  describe "test collections actions" do
    before(:all) do
    # so this part of the before :all runs only once
      unless @user = User.find_by_username('collections_scenario')
        truncate_all_tables
        load_scenario_with_caching(:collections)
        @user = User.find_by_username('collections_scenario')
      end
      @test_data  = EOL::TestInfo.load('collections')
      @collection = @test_data[:collection]
      EOL::Solr::CollectionItemsCoreRebuilder.begin_rebuild
    end

    describe 'GET show' do
      it 'should set view as options and currently selected view' do
        get :show, :id => @collection.id
        assigns[:view_as].should == @collection.view_style_or_default
        assigns[:view_as_options].should == [ViewStyle.list, ViewStyle.gallery, ViewStyle.annotated]
        get :show, :id => @collection.id, :view_as => ViewStyle.gallery.id
        assigns[:view_as].should == ViewStyle.gallery
      end
      describe '#login_with_open_authentication' do
        it 'should do nothing unless oauth_provider param is present' do
          get :show, :id => @collection.id
          response.status.should == 200
          response.should render_template('collections/show')
        end
        it 'should redirect to login unless user already logged in' do
          provider = 'aprovider'
          get :show, { :id => @collection.id, :oauth_provider => provider }
          session[:return_to].should == collection_url(@collection)
          expect(response).to redirect_to(login_url(:oauth_provider => provider))
          get :show, { :id => @collection.id, :oauth_provider => provider }, { :user_id => @user.id }
          response.should_not redirect_to(login_url(:oauth_provider => provider))
        end
        it 'should redirect to current url if it matches the session return to url and clear obsolete session data' do
          obsolete_oauth_session_data = {:provider_request_token_token => 'token',
            :provider_request_token_secret => 'secret',
            :provider_oauth_state => 'state'}
          return_to_url = collection_url(@collection)
          get :show, { :id => @collection.id, :oauth_provider => 'provider' },
                   obsolete_oauth_session_data.merge({ :return_to => return_to_url })
          obsolete_oauth_session_data.each{|k,v| session.has_key?(k.to_s).should be_false}
          expect(response).to redirect_to(return_to_url)
        end
      end
    end

    describe 'GET edit' do
      it 'should set view as options' do
        session[:user_id] = nil
        get :edit, { :id => @collection.id }, { :user_id => @collection.users.first.id, :user => @collection.users.first }
        assigns[:view_as_options].should == [ViewStyle.list, ViewStyle.gallery, ViewStyle.annotated]
      end
    end

    describe "#update" do
      it "When not logged in, users cannot update the description" do
        session[:user_id] = nil
        lambda { post :update, :id => @collection.id, :commit_edit_collection => 'Submit',
                             :collection => {:description => "New Description"}
        }.should raise_error(EOL::Exceptions::MustBeLoggedIn)
      end
      it "Unauthorized users cannot update the description" do
        user = User.gen
        lambda {
          session[:user_id] = user.id
          post :update, { :id => @collection.id, :commit_edit_collection => 'Submit',
                        :collection => {:description => "New Description"} },
                      { :user => user, :user_id => user.id }
        }.should raise_error(EOL::Exceptions::SecurityViolation)

      end
      it "Updates the description" do
        session[:user_id] = nil
        getter = lambda{
          session[:user_id] = @test_data[:user].id
          post :update, :id => @collection.id, :commit_edit_collection => 'Submit',  :collection => {:description => "New Description"}
          @collection.reload
        }
        getter.should change(@collection, :description)
      end
    end
  end

  # sync collections actions
  describe "collections actions synchronization" do
  # sync craete action
    describe 'create collection synchronization' do
      before(:each) do
        # prepare database for testing
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "collection_items", {})
        truncate_table(ActiveRecord::Base.connection, "special_collections", {})
        SpecialCollection.create_enumerated
        
               
        user_params = {:username => 'user_1', 
                         :given_name => 'user', 
                         :email => "user1@yahoo.com", 
                         :email_confirmation => "user1@yahoo.com", 
                         :entered_password => "HELLO", 
                         :entered_password_confirmation => "HELLO", 
                         :agreed_with_terms => 1,
                         :active => true}        
        @user = User.new(user_params)
        @user.save   
        @user[:site_id] = PEER_SITE_ID
        @user[:origin_id] = @user.id        
        @user.save             
        session[:user_id] = @user.id
      
      end
      it 'should save creating collection paramters in synchronization tables' do
        put :create, {:collection => { :name => 'newcollection' },
                                       :item_id => @user.id,
                                       :item_type => 'User'}

        # created collection
        created_collection =  Collection.find(2)
        created_collection.name.should == 'newcollection'
        
        user_collection = created_collection.users.first
        user_collection.id.should == @user.id
        
        collection_item = CollectionItem.first
        collection_item.name.should == "#{@user.username}"
        collection_item.collected_item_type.should == "User"
        collection_item.collected_item_id.should == "#{@user.id}".to_i
        collection_item.collection_id.should == "#{created_collection.id}".to_i

        # check sync_object_type
        type = SyncObjectType.first
        type.should_not be_nil
        type.object_type.should == "Collection"

        # check sync_object_actions
        action = SyncObjectAction.first
        action.should_not be_nil
        action.object_action.should == "create"

        # check peer logs
        peer_log = SyncPeerLog.first
        peer_log.should_not be_nil
        peer_log.sync_object_action_id.should == action.id
        peer_log.sync_object_type_id.should == type.id
        peer_log.user_site_id .should == PEER_SITE_ID
        peer_log.user_site_object_id.should == @user.id
        peer_log.sync_object_id.should == created_collection.id
        peer_log.sync_object_site_id.should == PEER_SITE_ID

        # check log action parameters
        collectionname_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "name")
        collectionname_parameter[0][:value].should == "newcollection"

        itemoriginid_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_origin_id")
        itemoriginid_parameter[0][:value].should == "#{@user.origin_id}"

        itemsiteid_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_site_id")
        itemsiteid_parameter[0][:value].should == "#{@user.site_id}"

        itemtype_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_type")
        itemtype_parameter[0][:value].should == 'User'

        itemname_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "item_name")
        itemname_parameter[0][:value].should == "#{@user.username}"

      end
    end
    
    # sync update action
    describe 'update collection synchronization' do
      before(:each) do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "collection_items", {})
        Activity.create_enumerated
        ViewStyle.create_enumerated
       
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
        @collection = Collection.create(:name => "collection")
        @collection.update_column(:origin_id, @collection.id)
        @collection.update_column(:site_id, PEER_SITE_ID)
        @collection.users = [@current_user]
       
      end
      
      it 'should save updating collection paramters in synchronization tables' do
         @file = ActionDispatch::Http::UploadedFile.new({
            :filename => "test.jpg",
            :type => "image/jpeg",
            :tempfile => File.new(Rails.root.join("test/fixtures/files/test.jpg")) })
       
      
        post :update, :id => @collection.id, :view_as => 2,
        :commit_edit_collection => 'Submit', :collection => { :name => 'newname', :logo =>  @file}
          
        # updated collection        
        created_collection =  @collection.reload
        created_collection.name.should == 'newname'

        # check sync_object_type
        type = SyncObjectType.first
        type.should_not be_nil
        type.object_type.should == "Collection"

        # check sync_object_actions
        action = SyncObjectAction.first
        action.should_not be_nil
        action.object_action.should == "update"

        # check peer logs
        peer_log = SyncPeerLog.first
        peer_log.should_not be_nil
        peer_log.sync_object_action_id.should == action.id
        peer_log.sync_object_type_id.should == type.id
        peer_log.user_site_id .should == PEER_SITE_ID
        peer_log.user_site_object_id.should == @current_user.id
        peer_log.sync_object_id.should == created_collection.id
        peer_log.sync_object_site_id.should == PEER_SITE_ID

        # check log action parameters
        collectionname_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "name")
        collectionname_parameter[0][:value].should == "newname"
        
        updated_at_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "updated_at")
        updated_at_parameter[0][:value].should == "#{created_collection.updated_at}"
        # # test sync upload logo
        # logo_file_name_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "logo_file_name")
        # logo_file_name_parameter[0][:value].should == created_collection.logo_file_name
#                     
        # logo_content_type_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "logo_content_type")
        # logo_content_type_parameter[0][:value].should == "#{created_collection.logo_content_type}"
#                     
        # logo_file_size_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "logo_file_size")
        # logo_file_size_parameter[0][:value].should == "#{created_collection.logo_file_size}"
#           
        # base_url_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "base_url")
        # base_url_parameter[0][:value].should == "#{$CONTENT_SERVER}content/"
#         
       # logo_cache_url_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "logo_cache_url")
       # logo_cache_url_parameter[0][:value].should == created_collection.logo_cache_url
      
      end
    end
    
    describe "syncronization of deleting a collection" do
      @collection = Collection.create(:name => "collection")
      @collection.update_column(:origin_id, @collection.id)
      @collection.update_column(:site_id, PEER_SITE_ID)
      post :update, :id => @collection.id
#      post :destroy, :id => @collection.id
    end
  end
end
