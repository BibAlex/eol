require "spec_helper"
  
describe User do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
    SpecialCollection.create_enumerated
  end
    
  describe ".create_user" do
    subject(:user) { User.find_by_origin_id_and_site_id(100, 2) }
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.user.id,
                                        user_site_object_id: 100, sync_object_id: 100, user_site_id: 2,
                                        sync_object_site_id: 2)
        parameters_values_hash = { language: "en", validation_code: "89accf204c74d07fbdb1c2bad027946818142efb",
          remote_ip: "127.0.0.1", username: "user100", agreed_with_terms: 1, collection_site_id: 2,
          collection_origin_id: 10 }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new user" do
        expect(user).not_to be_nil          
      end
      it "has the correct 'username'" do
        expect(user.username).to eq("user100")
      end
      it "has the correct 'language_id'" do
        expect(user.language_id).to eq(Language.english.id)
      end
      it "has the correct 'validation_code'" do
        expect(user.validation_code).to eq("89accf204c74d07fbdb1c2bad027946818142efb")
      end
      it "has the correct 'remote_ip'" do
        expect(user.remote_ip).to eq("127.0.0.1")
      end
      it "has the correct 'origin_id'" do
        expect(user.origin_id).to eq(100)
      end
      it "has the correct 'site_id'" do
        expect(user.site_id).to eq(2)
      end
      it "has the correct 'agreed_with_terms'" do
        expect(user.agreed_with_terms).to eq(!(1.zero?))
      end
      it "hasn't sync 'email'" do
        expect(user.email).to be_nil
      end
      it "hasn't sync 'password'" do
        expect(user.hashed_password).to be_nil
      end
      it "creates a watch collection for new user" do
        expect(user.watch_collection).not_to be_nil
      end
      after(:all) do
        if user
          user.watch_collection.destroy if user.watch_collection
          user.destroy
        end
      end
    end
  end
  
  describe ".update_user" do
    subject(:user) { User.first }
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: 2)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.user.id,
                                        user_site_object_id: user.origin_id, sync_object_id: user.origin_id, user_site_id: 2,
                                        sync_object_site_id: 2)
        parameters_values_hash = { username: "myusername", bio: "My bio", remote_ip: "127.0.0.2" }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        user.reload
      end
      it "updates 'username'" do
        expect(user.username).to eq("myusername")
      end
      it "updates 'bio'" do
        expect(user.bio).to eq("My bio")
      end
    end
    #TODO handle pull failures  
    context "when update fails because the user is not found" do
    end
  end
  
  describe ".activate_user" do
    subject(:user) { User.first }
    
    context "when successful activate" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: 2, active: false)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.activate.id, sync_object_type_id: SyncObjectType.user.id,
                                        user_site_object_id: user.origin_id, sync_object_id: user.origin_id, user_site_id: 2,
                                        sync_object_site_id: 2)
        sync_peer_log.process_entry
        user.reload
      end
      it "activates user" do        
        expect(user.active).to be_true
      end
      it "has the correct validation code" do        
        expect(user.validation_code).to be_nil
      end
    end
    #TODO handle pull failures  
    context "when activation fails because the user isn't found" do
    end
  end
  
  describe ".update_by_admin_user" do
    subject(:user) { User.first }
    
    context "when successful update" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: 2)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update_by_admin.id, sync_object_type_id: SyncObjectType.user.id,
                                        user_site_object_id: user.id+1, sync_object_id: user.origin_id, user_site_id: 2,
                                        sync_object_site_id: 2)
        parameters_values_hash = { username: "myusername", bio: "My bio", remote_ip: "127.0.0.2" }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
        user.reload
      end
      it "updates 'username'" do
        expect(user.username).to eq("myusername")
      end
      it "updates 'bio'" do
        expect(user.bio).to eq("My bio")
      end
    end
    #TODO handle pull failures  
    context "when update fails because the user isn't found" do
    end
  end
  
  describe ".hide_user" do
    subject(:user) { User.first }
    subject(:admin) { User.last }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
      admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.hide.id, 
                                      sync_object_type_id: SyncObjectType.user.id,
                                      user_site_object_id: admin.origin_id, 
                                      user_site_id: admin.site_id,
                                      sync_object_id: user.origin_id, 
                                      sync_object_site_id: user.site_id)
      sync_peer_log.process_entry
    end
    it "hides user" do
      expect(User.first.hidden).to eq(1)
    end
  end
  
  describe ".show _user" do
    subject(:user) { User.first }
    subject(:admin) { User.last }
    before(:all) do
      truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
      user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
      admin.update_attributes(origin_id: admin.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, 
                                      sync_object_type_id: SyncObjectType.user.id,
                                      user_site_object_id: admin.origin_id, 
                                      user_site_id: admin.site_id,
                                      sync_object_id: user.origin_id, 
                                      sync_object_site_id: user.site_id)
      sync_peer_log.process_entry
    end
    it "hides user" do
      expect(User.first.hidden).to eq(0)
    end
  end
end