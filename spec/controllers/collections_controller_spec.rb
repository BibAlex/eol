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
        get :show, id: @collection.id
        assigns[:view_as].should == @collection.view_style_or_default
        assigns[:view_as_options].should == [ViewStyle.list, ViewStyle.gallery, ViewStyle.annotated]
        get :show, id: @collection.id, view_as: ViewStyle.gallery.id
        assigns[:view_as].should == ViewStyle.gallery
      end
      describe '#login_with_open_authentication' do
        it 'should do nothing unless oauth_provider param is present' do
          get :show, id: @collection.id
          response.status.should == 200
          response.should render_template('collections/show')
        end
        it 'should redirect to login unless user already logged in' do
          provider = 'aprovider'
          get :show, id: @collection.id, oauth_provider: provider
          session[:return_to].should == collection_url(@collection)
          expect(response).to redirect_to(login_url(:oauth_provider => provider))
          get :show, { id: @collection.id, oauth_provider: provider }, { user_id: @user.id }
          response.should_not redirect_to(login_url(oauth_provider: provider))
        end
        it 'should redirect to current url if it matches the session return to url and clear obsolete session data' do
          obsolete_oauth_session_data = { provider_request_token_token: 'token',
            provider_request_token_secret: 'secret',
            provider_oauth_state: 'state' }
          return_to_url = collection_url(@collection)
          get :show, { id: @collection.id, oauth_provider: 'provider' },
                   obsolete_oauth_session_data.merge({ return_to: return_to_url })
          obsolete_oauth_session_data.each{ |k,v| session.has_key?(k.to_s).should be_false }
          expect(response).to redirect_to(return_to_url)
        end
      end
    end

    describe 'GET edit' do
      it 'should set view as options' do
        session[:user_id] = nil
        get :edit, { id: @collection.id }, { user_id: @collection.users.first.id, user: @collection.users.first }
        assigns[:view_as_options].should == [ViewStyle.list, ViewStyle.gallery, ViewStyle.annotated]
      end
    end

    describe "#update" do
      it "When not logged in, users cannot update the description" do
        session[:user_id] = nil
        lambda { post :update, id: @collection.id, commit_edit_collection: 'Submit',
                             collection: { description: "New Description" }
        }.should raise_error(EOL::Exceptions::MustBeLoggedIn)
      end
      it "Unauthorized users cannot update the description" do
        user = User.gen
        lambda {
          session[:user_id] = user.id
          post :update, { id: @collection.id, commit_edit_collection: 'Submit',
                        collection: { description: "New Description" } },
                      { user: user, user_id: user.id }
        }.should raise_error(EOL::Exceptions::SecurityViolation)
      end
      it "Updates the description" do
        session[:user_id] = nil
        getter = lambda{
          session[:user_id] = @test_data[:user].id
          post :update, id: @collection.id, commit_edit_collection: 'Submit',  collection: { description: "New Description" }
          @collection.reload
        }
        getter.should change(@collection, :description)
      end
    end
  end
  
  describe "collections actions synchronization" do
    before(:all) do
      truncate_all_tables
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
      Activity.create_enumerated
      ViewStyle.create_enumerated
    end
    
    describe "POST #create" do
      let(:create_collection_peer_log) { SyncPeerLog.first }
      let(:add_collection_item_peer_log) { SyncPeerLog.last }
      let(:user) { User.gen }
      subject(:collection) { Collection.last }
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          post :create, { collection: { name: 'newcollection' }, item_id: user.id,
                         item_type: 'User' }
        end
        it "creates sync peer log for 'creating new collection'" do
          expect(create_collection_peer_log).not_to be_nil
        end
        it "has correct action for 'creating new collection'" do
          expect(create_collection_peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type for 'creating new collection'" do
          expect(create_collection_peer_log.sync_object_type_id).to eq(SyncObjectType.collection.id)
        end
        it "has correct 'user_site_id' for 'creating new collection'" do
          expect(create_collection_peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id' for 'creating new collection'" do
          expect(create_collection_peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id' for 'creating new collection'" do
          expect(create_collection_peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id' for 'creating new collection'" do
          expect(create_collection_peer_log.sync_object_id).to eq(collection.origin_id)
        end
        it "creates sync log action parameter for 'name'" do
          collectionname_parameter = SyncLogActionParameter.where(peer_log_id: create_collection_peer_log.id, parameter: "name")
          expect(collectionname_parameter[0][:value]).to eq("newcollection")
        end
        it "creates sync peer log for 'add collection item'" do
          expect(add_collection_item_peer_log).not_to be_nil
        end
        it "has correct action for 'add collection item'" do
          expect(add_collection_item_peer_log.sync_object_action_id).to eq(SyncObjectAction.add.id)
        end
        it "has correct type for 'add collection item'" do
          expect(add_collection_item_peer_log.sync_object_type_id).to eq(SyncObjectType.collection_item.id)
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
          expect(add_collection_item_peer_log.sync_object_id).to eq(collection.origin_id)
        end
        it "creates sync log action parameter for 'item_id'" do
          collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "item_id")
          expect(collection_origin_ids_parameter[0][:value]).to eq("#{user.origin_id}")
        end
        it "creates sync log action parameter for 'item_site_id'" do
          collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "item_site_id")
          expect(collection_site_ids_parameter[0][:value]).to eq("#{user.site_id}")
        end
        it "creates sync log action parameter for 'collected_item_type'" do
          collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "collected_item_type")
          expect(collected_item_type_parameter[0][:value]).to eq("User")
        end
        it "creates sync log action parameter for 'collected_item_name'" do
          collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: add_collection_item_peer_log.id, parameter: "collected_item_name")
          expect(collected_item_name_parameter[0][:value]).to eq("#{user.summary_name}")
        end
      end
      
      context "when creation fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          post :create, { collection: { name: 'newcollection' }, item_id: user.id,
                         item_type: 'User' }
        end
        it "doesn't create sync peer log for 'creating new collection'" do
          expect(create_collection_peer_log).to be_nil
        end
        it "doesn't create sync peer log for 'add collection item'" do
          expect(add_collection_item_peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.first }
      let(:user) { User.gen }
      subject(:collection) { Collection.gen }
      context "when successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          put :update,  id: collection.id, view_as: 2,
                        commit_edit_collection: 'Submit', collection: { name: 'newname' }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.collection.id)
        end
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(collection.origin_id)
        end
        it "creates sync log action parameter for 'name'" do
          collectionname_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "name")
          expect(collectionname_parameter[0][:value]).to eq("newname")
        end
        it "creates sync log action parameter for 'updated_at'" do
          collection.reload
          updated_at_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "updated_at")
          expect(updated_at_parameter[0][:value]).to eq(collection.updated_at.utc.to_s(:db))
        end
      end
      
      context "when update fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          expect{ put :update,  id: collection.id, view_as: 2,
                        commit_edit_collection: 'Submit', collection: { name: 'newname' } }.to raise_error(EOL::Exceptions::MustBeLoggedIn)
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
    
    describe "DELETE #destroy" do
      let(:peer_log) { SyncPeerLog.first }
      let(:user) { User.gen }
      subject(:collection) { Collection.gen }
      context "when successful deletion" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          delete :destroy,  id: collection.id
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.collection.id)
        end
        it "has correct 'user_site_id'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(user.origin_id)
        end
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(collection.origin_id)
        end
      end
      
      context "when deletion fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users",
                           "collection_items","collections"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          expect{ delete :destroy,  id: collection.id }.to raise_error(EOL::Exceptions::MustBeLoggedIn)
        end
        it "doesn't create sync peer log" do
          expect(peer_log).to be_nil
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
      end
    end
  end
end