require File.dirname(__FILE__) + '/../../spec_helper'

describe Forums::CategoriesController do

  before(:all) do
    load_foundation_cache
    @normal_user = User.gen
    @admin = User.gen(:admin => true)
  end

  describe 'POST create' do
    it "must be an admin to create" do
      session[:user_id] = nil
      lambda { post :create, :forum_category => { :title => 'New category' }
        }.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it "must be an admin to create" do
      session[:user_id] = @normal_user.id
      lambda { post :create, :forum_category => { :title => 'New category' }
        }.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it "admins can create" do
      session[:user_id] = @admin.id
      expect { post :create, :forum_category => { :title => 'New category' }
        }.not_to raise_error
    end
  end

  describe 'POST move_up, move_down' do
    before(:all) do
      5.times { ForumCategory.gen }
    end
    before(:each) do
      session[:user_id] = @admin.id
    end

    it "should move categories up" do
      last_category = ForumCategory.order(:view_order).last
      original_view_order = last_category.view_order
      post :move_up, :id => last_category.id
      last_category.reload.view_order.should == original_view_order - 1
      ForumCategory.find_by_view_order(original_view_order).should_not be_nil
      ForumCategory.find_by_view_order(original_view_order).should_not == last_category
    end

    it "should not move first category up" do
      post :move_up, :id => ForumCategory.order(:view_order).first.id
      flash[:error].should == I18n.t('forums.categories.move_failed')
    end

    it "should move categories down" do
      first_category = ForumCategory.order(:view_order).first
      original_view_order = first_category.view_order
      post :move_down, :id => first_category.id
      first_category.reload.view_order.should == original_view_order + 1
      ForumCategory.find_by_view_order(original_view_order).should_not be_nil
      ForumCategory.find_by_view_order(original_view_order).should_not == first_category
    end

    it "should not move last category down" do
      post :move_down, :id => ForumCategory.order(:view_order).last.id
      flash[:error].should == I18n.t('forums.categories.move_failed')
    end
  end

  describe 'PUT update' do
    before(:each) do
      session[:user_id] = @admin.id
    end
    it "should update categories" do
      c = ForumCategory.gen(:title => 'Test title', :description => 'Test description')
      put :update, :id => c.id, :forum_category => {
        :title => "New title",
        :description => "New description" }
      c.reload
      c.title.should == "New title"
      c.description.should == "New description"
    end
  end

  describe 'DELETE destroy' do
    it 'must be admin to delete' do
      c = ForumCategory.gen
      session[:user_id] = nil
      lambda { post :destroy, :id => c.id }.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'must be admin to delete' do
      c = ForumCategory.gen
      session[:user_id] = @normal_user.id
      lambda { post :destroy, :id => c.id }.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should allow admins to delete posts' do
      c = ForumCategory.gen
      session[:user_id] = @admin.id
      expect { post :destroy, :id => c.id }.not_to raise_error
    end
  end
  
  describe "Synchronization" do
    describe "POST #create" do
      let(:current_user) { User.first }
      let(:type) { SyncObjectType.category }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      before do
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        post :create,
          forum_category: { title: "cat_title", description: "cat_description" }
      end
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates sync peer log with correct sync_object_action" do
        expect(peer_log.sync_object_action_id).to eq(action.id)
      end
      it "creates sync peer log with correct sync_object_type" do
        expect(peer_log.sync_object_type_id).to eq(type.id)
      end
      it "creates sync peer log with correct user_site_id" do
        expect(peer_log.user_site_id).to eq(current_user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(current_user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(ForumCategory.last.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(ForumCategory.last.site_id)
      end
      it "creates sync log action parameter for title" do
        title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
        expect(title_parameter[0][:value]).to eq("cat_title")
      end
      it "creates sync log action parameter for description" do
        description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
        expect(description_parameter[0][:value]).to eq("cat_description")
      end
      after(:each) do
        ForumCategory.last.destroy if ForumCategory.last
      end
    end
    
    describe "PUT #update" do
      let(:current_user) { User.first }
      let(:type) { SyncObjectType.category }
      let(:action) { SyncObjectAction.update }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:category) { ForumCategory.gen }
      before do
        category.update_attributes(origin_id: category.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        put :update,
          forum_category: { title: "new_cat_title", description: "new_cat_description" },
            id: category.id
      end
      it "creates sync peer log" do
        expect(peer_log).not_to be_nil
      end
      it "creates sync peer log with correct sync_object_action" do
        expect(peer_log.sync_object_action_id).to eq(action.id)
      end
      it "creates sync peer log with correct sync_object_type" do
        expect(peer_log.sync_object_type_id).to eq(type.id)
      end
      it "creates sync peer log with correct user_site_id" do
        expect(peer_log.user_site_id).to eq(current_user.site_id)
      end
      it "creates sync peer log with correct user_site_object_id" do
        expect(peer_log.user_site_object_id).to eq(current_user.origin_id)
      end
      it "creates sync peer log with correct sync_object_id" do
        expect(peer_log.sync_object_id).to eq(category.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(category.site_id)
      end
      it "creates sync log actionForumCategory parameter for title" do
        title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "title")
        expect(title_parameter[0][:value]).to eq("new_cat_title")
      end
      it "creates sync log action parameter for description" do
        description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
        expect(description_parameter[0][:value]).to eq("new_cat_description")
      end
      after(:each) do
        if ForumCategory.find(category.id)
          ForumCategory.find(category.id).destroy
        end
      end
    end
  end
end
