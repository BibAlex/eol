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
  
  describe "synchronization" do
    before(:all) do
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
    end
    
    describe "DELETE #destroy" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.delete.id, SyncObjectType.category.id,
                                          forum_category.origin_id, PEER_SITE_ID).first }
      let(:user) { User.first }
      subject(:forum_category) { ForumCategory.gen }
      
      context "when successful destroy" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID,
                                 admin: 1)
          session[:user_id] = user.id
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          delete :destroy, { id: forum_category.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.category.id)
        end
        it "sync peer log 'user_site_id' equal 'PEER_SITE_ID'" do
          expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'user_id'" do
          expect(peer_log.user_site_object_id).to eq(user.id)
        end
        it "has correct 'object_site_id'" do
          expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
        end
        it "has correct 'object_id'" do
          expect(peer_log.sync_object_id).to eq(forum_category.origin_id)
        end
        after do
          forum_category.destroy if forum_category
        end
      end
    end
  end
end
