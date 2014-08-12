require "spec_helper"

describe ForumsController do

  before(:all) do
    load_foundation_cache
  end

  describe 'POST create' do
    it "When not logged in, users cannot update the description" do
      post :create, :forum => {
        :forum_category_id => ForumCategory.gen.id,
        :name => "Sdasdf",
        :description => "4fasfdasd" }
      response.header["Location"].should =~ /\/login/
    end
  end

  describe 'DELETE destroy' do
    it 'should not allow unauthorized deleting' do
      forum = Forum.gen
      session[:user_id] = nil
      lambda { post :destroy, :id => forum.id }.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should allow admins to delete forums' do
      forum = Forum.gen
      session[:user_id] = User.gen(:admin => 1).id
      expect { post :destroy, :id => forum.id }.not_to raise_error
    end

    it 'should not allow unauthorized moving' do
      forum = Forum.gen
      session[:user_id] = nil
      expect { post :move_up, :id => forum.id }.to raise_error(EOL::Exceptions::SecurityViolation)
      expect { post :move_down, :id => forum.id }.to raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should allow admins to move forums' do
      forum = Forum.gen
      session[:user_id] = User.gen(:admin => 1).id
      expect { post :move_up, :id => forum.id }.not_to raise_error
      expect { post :move_down, :id => forum.id }.not_to raise_error
    end

    it 'should not allow unauthorized creating' do
      session[:user_id] = nil
      get :create
      response.header["Location"].should =~ /\/login/
    end

    it 'should allow admins to create forums' do
      session[:user_id] = User.gen(:admin => 1).id
      get :create
      response.header["Location"].should_not =~ /\/login/
    end
  end
  
  describe "Synchronization" do
    before(:all) do
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
    end
      
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.create.id, SyncObjectType.forum.id,
                                          forum.origin_id, PEER_SITE_ID).first }
      let(:user) { User.first }
      let(:forum_category) { ForumCategory.gen }
      subject(:forum) { Forum.last }
      
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID,
                                 admin: 1)
          session[:user_id] = user.id
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          post :create, { forum: { forum_category_id: forum_category.id, name: "forum", 
                          description: "forum description" } }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.forum.id)
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
          expect(peer_log.sync_object_id).to eq(forum.origin_id)
        end
        it "creates sync log action parameter for 'name'" do
          name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "name")
          expect(name_parameter[0][:value]).to eq("forum")
        end
        it "creates sync log action parameter for 'description'" do
          description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
          expect(description_parameter[0][:value]).to eq("forum description")
        end
        it "creates sync log action parameter for 'forum_category_origin_id'" do
          forum_category_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "forum_category_origin_id")
          expect(forum_category_origin_id_parameter[0][:value].to_i).to eq(forum_category.origin_id)
        end
        it "creates sync log action parameter for 'forum_category_site_id'" do
          forum_category_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "forum_category_site_id")
          expect(forum_category_site_id_parameter[0][:value].to_i).to eq(forum_category.site_id)
        end
        after do
          forum.destroy if forum
          forum_category.destroy if forum_category
        end
      end
      
      context "when creation fails because 'name' should not be empty" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID,
                                 admin: 1)
          session[:user_id] = user.id
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          post :create, { forum: { forum_category_id: forum_category.id, 
                          description: "forum description" } }
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum.destroy if forum
          forum_category.destroy if forum_category
        end
      end
      
      context "when creation fails because the user hasn't privillige to create forum" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 0)
          session[:user_id] = user.id
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          expect{ post :create, { forum: { forum_category_id: forum_category.id, name: "forum", 
                          description: "forum description" } } }.to raise_error(EOL::Exceptions::SecurityViolation)
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum.destroy if forum
          forum_category.destroy if forum_category
        end
      end
      
      context "when creation fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          post :create, { forum: { forum_category_id: forum_category.id, name: "forum", 
                          description: "forum description" } }
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum.destroy if forum
          forum_category.destroy if forum_category
        end
      end
    end
    
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.update.id, SyncObjectType.forum.id,
                                          forum.origin_id, PEER_SITE_ID).first }
      let(:user) { User.first }
      let(:forum_category) { ForumCategory.gen }
      subject(:forum) { Forum.gen(user_id: user.id) }
      
      context "when successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID,
                                 admin: 1)
          session[:user_id] = user.id
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          forum.update_attributes(origin_id: forum.id, site_id: PEER_SITE_ID)
          put :update, { forum: { forum_category_id: forum_category.id, name: "forum", 
                                   description: "forum description" },
                           id: forum.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.forum.id)
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
          expect(peer_log.sync_object_id).to eq(forum.origin_id)
        end
        it "creates sync log action parameter for 'name'" do
          name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "name")
          expect(name_parameter[0][:value]).to eq("forum")
        end
        it "creates sync log action parameter for 'description'" do
          description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
          expect(description_parameter[0][:value]).to eq("forum description")
        end
        it "creates sync log action parameter for 'forum_category_origin_id'" do
          forum_category_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "forum_category_origin_id")
          expect(forum_category_origin_id_parameter[0][:value].to_i).to eq(forum_category.origin_id)
        end
        it "creates sync log action parameter for 'forum_category_site_id'" do
          forum_category_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "forum_category_site_id")
          expect(forum_category_site_id_parameter[0][:value].to_i).to eq(forum_category.site_id)
        end
        after do
          forum.destroy if forum
          forum_category.destroy if forum_category
        end
      end
    end
    
    describe "DELETE #destroy" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.delete.id, SyncObjectType.forum.id,
                                          forum.origin_id, PEER_SITE_ID).first }
      let(:user) { User.first }
      let(:forum_category) { ForumCategory.gen }
      subject(:forum) { Forum.gen(user_id: user.id) }
      
      context "when successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID,
                                 admin: 1)
          session[:user_id] = user.id
          forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
          forum.update_attributes(origin_id: forum.id, site_id: PEER_SITE_ID)
          delete :destroy, { id: forum.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.delete.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.forum.id)
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
          expect(peer_log.sync_object_id).to eq(forum.origin_id)
        end
        after do
          forum.destroy if forum
          forum_category.destroy if forum_category
        end
      end
    end
  end
end
