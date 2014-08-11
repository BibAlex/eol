require File.dirname(__FILE__) + '/../../spec_helper'

describe Forums::PostsController do

  before(:all) do
    load_foundation_cache
  end

  describe 'GET show' do
    it "should increment its topics view count" do
      post = ForumPost.gen
      get :show, :id => post.id
      post.forum_topic.reload.number_of_views.should == 1
      5.times do
        get :show, :id => post.id
      end
      post.forum_topic.reload.number_of_views.should == 6
    end
  end

  describe 'POST create' do
    it "must be logged in to create" do
      topic = ForumTopic.gen
      post :create, :topic_id => topic.id,
        :forum_post => {
          :forum_topic_id => topic.id,
          :subject => "post subject",
          :text => "post body" }
      response.header["Location"].should =~ /\/login/
    end

    it "logged in users can create" do
      session[:user_id] = User.gen(:admin => 1).id
      topic = ForumTopic.gen
      post :create, :topic_id => topic.id,
        :forum_post => {
          :forum_topic_id => topic.id,
          :subject => "post subject",
          :text => "post body" }
      response.header["Location"].should_not =~ /\/login/
    end
  end

  describe 'DELETE destroy' do
    it 'should redirect non-logged in users to login before deleting' do
      p = ForumPost.gen
      session[:user_id] = nil
      expect { post :destroy, :id => p.id }.not_to raise_error
      response.header["Location"].should =~ /\/login/
    end

    it 'should not allow unauthorized users to delete' do
      p = ForumPost.gen
      session[:user_id] = User.gen.id
      lambda { post :destroy, :id => p.id }.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should allow owners to delete posts' do
      p = ForumPost.gen
      session[:user_id] = p.user.id
      expect { post :destroy, :id => p.id }.not_to raise_error
    end

    it 'should allow admins to delete posts' do
      p = ForumPost.gen
      session[:user_id] = User.gen(:admin => 1).id
      expect { post :destroy, :id => p.id }.not_to raise_error
    end
  end
  
  describe "synchronization" do
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.create.id, SyncObjectType.post.id,
                                          forum_post.origin_id, PEER_SITE_ID).first }
      let(:user) { User.first }
      let(:topic) { ForumTopic.gen }
      subject(:forum_post) { ForumPost.last }
      
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
          session[:user_id] = user.id
          topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
          post :create, { forum_post: { forum_topic_id: topic.id, subject: "post subject", 
                                        text: "post body" },
                          forum_id: Forum.first.id, topic_id: topic.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.post.id)
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
          expect(peer_log.sync_object_id).to eq(forum_post.origin_id)
        end
        it "creates sync log action parameter for 'subject'" do
          subject_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "subject")
          expect(subject_parameter[0][:value]).to eq("post subject")
        end
        it "creates sync log action parameter for 'text'" do
          text_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "text")
          expect(text_parameter[0][:value]).to eq("post body")
        end
        it "creates sync log action parameter for 'topic_origin_id'" do
          topic_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "topic_origin_id")
          expect(topic_origin_id_parameter[0][:value].to_i).to eq(topic.origin_id)
        end
        it "creates sync log action parameter for 'topic_site_id'" do
          topic_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "topic_site_id")
          expect(topic_site_id_parameter[0][:value].to_i).to eq(topic.site_id)
        end
        after do
          forum_post.destroy if forum_post
          topic.destroy if topic
        end
      end
      
      context "when creation fails because 'text' should not be empty" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
          post :create, { forum_post: { forum_topic_id: topic.id, subject: "post subject" },
                          forum_id: Forum.first.id, topic_id: topic.id }
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum_post.destroy if forum_post
          topic.destroy if topic
        end
      end
      
      context "when creation fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
          topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
          post :create, { forum_post: { forum_topic_id: topic.id, subject: "post subject", 
                                        text: "post body" },
                          forum_id: Forum.first.id, topic_id: topic.id }
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum_post.destroy if forum_post
          topic.destroy if topic
        end
      end
    end
    
    describe "PUT #update" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.update.id, SyncObjectType.post.id,
                                          forum_post.origin_id, PEER_SITE_ID).first }
      let(:user) { User.first }
      let(:topic) { ForumTopic.gen }
      subject(:forum_post) { ForumPost.gen(user_id: user.id, forum_topic_id: topic.id) }
      
      context "when successful update" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
          session[:user_id] = user.id
          topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
          forum_post.update_attributes(origin_id: forum_post.id, site_id: PEER_SITE_ID)
          put :update, { forum_post: { subject: "updated post subject", text: "updated post body" },
                         forum_id: Forum.first.id, topic_id: topic.id,
                         id: forum_post.id }
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.post.id)
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
          expect(peer_log.sync_object_id).to eq(forum_post.origin_id)
        end
        it "creates sync log action parameter for 'subject'" do
          subject_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "subject")
          expect(subject_parameter[0][:value]).to eq("updated post subject")
        end
        it "creates sync log action parameter for 'text'" do
          text_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "text")
          expect(text_parameter[0][:value]).to eq("updated post body")
        end
        after do
          forum_post.destroy if forum_post
          topic.destroy if topic
        end
      end
      
      context "when creation fails because 'text' should not be empty" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
          session[:user_id] = user.id
          topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
          forum_post.update_attributes(origin_id: forum_post.id, site_id: PEER_SITE_ID)
          put :update, { forum_post: { subject: "updated post subject", text: "" },
                         forum_id: Forum.first.id, topic_id: topic.id,
                         id: forum_post.id }
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum_post.destroy if forum_post
          topic.destroy if topic
        end
      end
      
      context "when creation fails because the user isn't logged in" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
          topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
          forum_post.update_attributes(origin_id: forum_post.id, site_id: PEER_SITE_ID)
          put :update, { forum_post: { subject: "updated post subject", text: "updated post body" },
                         forum_id: Forum.first.id, topic_id: topic.id,
                         id: forum_post.id }
        end
        it "doesn't create sync peer log" do
          expect(SyncPeerLog.all).to be_blank
        end
        it "doesn't create sync log action parameters" do
          expect(SyncLogActionParameter.all).to be_blank
        end
        after do
          forum_post.destroy if forum_post
          topic.destroy if topic
        end
      end
    end
  end
end
