require "spec_helper"

def log_in_for_controller(controller, user)
  session[:user_id] = user.id
  controller.set_current_user = user
end

describe CommunitiesController do

  before :all do
    load_scenario_with_caching(:communities)
  end
  describe "syncronization" do
    before :each do
      truncate_table(ActiveRecord::Base.connection, "users", {})
      truncate_table(ActiveRecord::Base.connection, "members", {})
      truncate_table(ActiveRecord::Base.connection, "communities", {})
      truncate_table(ActiveRecord::Base.connection, "collections_communities", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
      truncate_table(ActiveRecord::Base.connection, "special_collections", {})
    end
    
    it "should syncronize create community action" do
      SpecialCollection.create(:name => "watch")
      
      user = User.gen
      user.origin_id = user.id
      user.site_id = 1
      user.save
      
      collection = Collection.gen
      collection.origin_id = collection.id
      collection.site_id = 1
      collection.save
      
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      post :create, {:community => {:name => "name",
                                   :description => "desc"},
                    :collection_id => collection.id}
      
      created_community = Community.first
      created_community.should_not be_nil
      created_community.name.should == "name"
      created_community.description.should == "desc"
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Community"

      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "create"

      # check peer log for creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id.should == user.site_id
      peer_log.user_site_object_id.should == user.origin_id
      peer_log.sync_object_id.should == created_community.origin_id
      peer_log.sync_object_site_id.should == created_community.site_id

      # check log action parameters
      community_name_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "community_name")
      community_name_parameter[0][:value].should == "name"
        
      community_description_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "community_description")
      community_description_parameter[0][:value].should == "desc"
        
      collection_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_origin_id")
      collection_origin_id_parameter[0][:value].should == "#{collection.origin_id}"
          
      collection_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "collection_site_id")
      collection_site_id_parameter[0][:value].should == "#{collection.site_id}"
    end
    
    it "should syncronize update community action" do
      SpecialCollection.create(:name => "watch")
            
      user = User.gen
      user.origin_id = user.id
      user.site_id = 1
      user.save
      
      collection = Collection.gen
      collection.origin_id = collection.id
      collection.site_id = 1
      collection.save
      
      community = Community.gen
      community.name = "name"
      community.description = "desc"
      community.origin_id = community.id
      community.site_id = 1
      community.save
      community.add_member(user)
      community.members[0].update_column(:manager, 1)
      
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      put :update, {:community_id => community.id,
                    :id => community.id,
                    :community => {:id => community.id,
                                   :name => "new_name",
                                   :description => "new_desc"},
                    :collection_id => collection.id}
                    
      updated_community = Community.find_by_id(community.id)
      updated_community.name.should == "new_name"
      updated_community.description.should == "new_desc"
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Community"

      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "update"

      # check peer log for creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id.should == user.site_id
      peer_log.user_site_object_id.should == user.origin_id
      peer_log.sync_object_id.should == Community.find_by_id(community.id).origin_id
      peer_log.sync_object_site_id.should == Community.find_by_id(community.id).site_id

      # check log action parameters
      community_name_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "community_name")
      community_name_parameter[0][:value].should == "new_name"
        
      community_description_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "community_description")
      community_description_parameter[0][:value].should == "new_desc"
        
    end
    
    it "should syncronize delete community action" do
      SpecialCollection.create(:name => "watch")
            
      user = User.gen
      user.origin_id = user.id
      user.site_id = 1
      user.save
      
      collection = Collection.gen
      collection.origin_id = collection.id
      collection.site_id = 1
      collection.save
      
      community = Community.gen
      community.name = "name"
      community.description = "desc"
      community.origin_id = community.id
      community.site_id = 1
      community.published = 1
      community.save
      community.add_member(user)
      community.members[0].update_column(:manager, 1)
      
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      get :delete, {:community_id => community.id,
                    :id => community.id,
                    :community => {:id => community.id,
                                   :name => "new_name",
                                   :description => "new_desc"},
                    :collection_id => collection.id}
                    
      Community.first.published.should be_false
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Community"

      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "delete"

      # check peer log for creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id.should == user.site_id
      peer_log.user_site_object_id.should == user.origin_id
      peer_log.sync_object_id.should == community.origin_id
      peer_log.sync_object_site_id.should == community.site_id
    end
    
    it "should syncronize join community action" do
      CuratorCommunity.build
      
      SpecialCollection.create(:name => "watch")
      
      user = User.gen
      user.origin_id = user.id
      user.site_id = 1
      user.save
            
      collection = Collection.gen
      collection.origin_id = collection.id
      collection.site_id = 1
      collection.save
      
      community = Community.gen
      community.name = "name"
      community.description = "desc"
      community.origin_id = community.id
      community.site_id = 1
      community.save
      
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      get :join, {:community_id => community.id,
                    :id => community.id,
                    :community => {:id => community.id,
                                   :name => "new_name",
                                   :description => "new_desc"},
                    :collection_id => collection.id}
      updated_community = Community.find_by_id(community.id)
      updated_community.members.count.should == 1
      updated_community.members[0].user_id.should == user.id
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Community"

      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "join"

      # check peer log for creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id.should == user.site_id
      peer_log.user_site_object_id.should == user.origin_id
      peer_log.sync_object_id.should == community.origin_id
      peer_log.sync_object_site_id.should == community.site_id 
    end
    
    it "should syncronize leave community action" do
      CuratorCommunity.build
      
      SpecialCollection.create(:name => "watch")
      
      user = User.gen
      user.origin_id = user.id
      user.site_id = 1
      user.save
            
      collection = Collection.gen
      collection.origin_id = collection.id
      collection.site_id = 1
      collection.save
      
      community = Community.gen
      community.name = "name"
      community.description = "desc"
      community.origin_id = community.id
      community.site_id = 1
      community.add_member(user)
      community.save
      
      allow(controller).to receive(:current_user) { user }
      log_in_for_controller(controller, user)
      
      get :leave, {:community_id => community.id,
                    :id => community.id,
                    :community => {:id => community.id,
                                   :name => "new_name",
                                   :description => "new_desc"},
                    :collection_id => collection.id}
      updated_community = Community.find_by_id(community.id)
      updated_community.members.count.should == 0
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "Community"

      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "leave"

      # check peer log for creating new collection
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id.should == user.site_id
      peer_log.user_site_object_id.should == user.origin_id
      peer_log.sync_object_id.should == community.origin_id
      peer_log.sync_object_site_id.should == community.site_id 
    end
  end
end