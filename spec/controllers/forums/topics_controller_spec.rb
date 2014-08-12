require File.dirname(__FILE__) + '/../../spec_helper'

describe Forums::TopicsController do

  before(:all) do
    load_foundation_cache
  end
  
  describe "Synchronization" do
    describe "POST #create" do
      let(:current_user) { User.first }
      let(:type) { SyncObjectType.topic }
      let(:action) { SyncObjectAction.create }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:forum) { Forum.gen }
      before do
        forum.update_attributes(origin_id: forum.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        post :create,
          forum_topic: { forum_id: forum.id, 
                         forum_posts_attributes: { "0" => { subject: "new_topic_subject", 
                                                             text: "new_topic_text" } } },
          forum_id: forum.id
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
        expect(peer_log.sync_object_id).to eq(ForumTopic.last.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(ForumTopic.last.site_id)
      end
      it "creates sync log action parameter for forum_origin_id" do
        forum_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "forum_origin_id")
        expect(forum_origin_id_parameter[0][:value]).to eq(forum.origin_id.to_s)
      end
      it "creates sync log action parameter for forum_site_id" do
        forum_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "forum_site_id")
        expect(forum_site_id_parameter[0][:value]).to eq(forum.site_id.to_s)
      end
      it "creates sync log action parameter for subject" do
        subject_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "subject")
        expect(subject_parameter[0][:value]).to eq("new_topic_subject")
      end
      it "creates sync log action parameter for text" do
        text_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "text")
        expect(text_parameter[0][:value]).to eq("new_topic_text")
      end
      it "creates sync log action parameter for first_post_origin_id" do
        first_post_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "first_post_origin_id")
        expect(first_post_origin_id_parameter[0][:value]).to eq(ForumTopic.last.first_post.origin_id.to_s)
      end
      it "creates sync log action parameter for first_post_site_id" do
        first_post_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "first_post_site_id")
        expect(first_post_site_id_parameter[0][:value]).to eq(ForumTopic.last.first_post.site_id.to_s)
      end
      after(:each) do
        ForumTopic.last.destroy if ForumTopic.last
        Forum.find(forum.id).destroy if Forum.find(forum.id) 
      end
    end
    
    describe "DELETE #destroy" do
      let(:current_user) { User.first }
      let(:type) { SyncObjectType.topic }
      let(:action) { SyncObjectAction.delete }
      let(:peer_log) { SyncPeerLog.find_by_sync_object_action_id_and_sync_object_type_id(action.id, type.id) }
      let(:topic) { ForumTopic.gen }
      before do
        topic.update_attributes(origin_id: topic.id, site_id: PEER_SITE_ID)
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID, admin: 1)
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        allow(controller).to receive(:current_user) { current_user }
        session[:user_id] = current_user.id
        delete :destroy,
          id: topic.id 
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
        expect(peer_log.sync_object_id).to eq(topic.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(topic.site_id)
      end
      
      after(:each) do
        ForumTopic.find(topic.id).destroy if ForumTopic.find(topic.id)
      end  
    end
  end
end