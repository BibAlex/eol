require "spec_helper"

describe SyncPeerLog do

  describe "process pull" do
    
    before(:all) do
      truncate_all_tables
      load_foundation_cache
      SyncObjectType.create_enumerated
      SyncObjectAction.create_enumerated
      SpecialCollection.create_enumerated
      Visibility.create_enumerated
      Activity.create_enumerated
    end
    
    describe("data_object Synchronization") do
      
      before(:all) do
        SpecialCollection.create(:name => "watch")
      end
        
      let(:user) {User.first}
      let(:data_object) {DataObject.first}
      let(:he) {HierarchyEntry.first}
      let(:comment) {Comment.gen}
      let(:taxon_concept) {TaxonConcept.first}
      before(:all) do
        user.update_attributes(curator_approved: 1, curator_level_id: 1)
        data_object.update_attributes(origin_id: data_object.id, site_id: PEER_SITE_ID)
        he.update_attributes(origin_id: he.id, site_id: PEER_SITE_ID)
        comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
        taxon_concept.update_attributes(origin_id: taxon_concept.id, site_id: PEER_SITE_ID)
        DataObjectsTaxonConcept.create(data_object_id: data_object.id, taxon_concept_id: taxon_concept.id)
        UsersDataObject.create(user_id: user.id, taxon_concept_id: taxon_concept.id, data_object_id: data_object.id)
      end
      describe ".curate_association" do
        before do
          
          @cdoh = CuratedDataObjectsHierarchyEntry.create(:vetted_id => Vetted.first.id,
                         :visibility_id => Visibility.invisible.id, :user_id => user.id, 
                         :data_object_guid => data_object.guid, :hierarchy_entry_id => he.id,
                         :data_object_id => data_object.id) 
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.curate_associations.id,
                                          sync_object_type_id: SyncObjectType.data_object.id,
                                          user_site_object_id: data_object.site_id, 
                                          sync_object_id: data_object.origin_id, 
                                          user_site_id: user.site_id,
                                          sync_object_site_id: user.origin_id)
          parameters = ["language", "vetted_view_order", "curation_comment_origin_id", 
                        "curation_comment_site_id", "untrust_reasons", 
                        "visibility_label", "taxon_concept_origin_id", "taxon_concept_site_id","hierarchy_entry_origin_id", "hierarchy_entry_site_id"]
          values = ["en", "1", "#{comment.origin_id}", 
                    "#{comment.site_id}", "misidentified,", "Visible", 
                    "#{taxon_concept.origin_id}", "#{taxon_concept.site_id}", "#{he.origin_id}", "#{he.site_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "should curate association" do
          cdoh = CuratedDataObjectsHierarchyEntry.find(@cdoh.id)
          expect(cdoh.visibility_id).to eq(Visibility.visible.id)
        end
      end
      
      describe ".add_association" do
        before(:each) do
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.save_association.id,
                                          sync_object_type_id: SyncObjectType.data_object.id,
                                          user_site_object_id: data_object.site_id, 
                                          sync_object_id: data_object.origin_id, 
                                          user_site_id: user.site_id,
                                          sync_object_site_id: user.origin_id)
          parameters = ["hierarchy_entry_origin_id", "hierarchy_entry_site_id"]
          values = ["#{he.origin_id}", "#{he.site_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "should add association" do
          cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(he.id, data_object.id)
          cdoh.should_not be_nil
        end
      end
      
      describe ".remove_association" do
        before(:each) do
          cdoh = CuratedDataObjectsHierarchyEntry.create(:vetted_id => Vetted.first.id,
                  :visibility_id => Visibility.visible.id, :user_id => user.id, 
                  :data_object_guid => data_object.guid, :hierarchy_entry_id => he.id,
                  :data_object_id => data_object.id) 
         
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.remove_association.id,
                                                    sync_object_type_id: SyncObjectType.data_object.id,
                                                    user_site_object_id: data_object.site_id, 
                                                    sync_object_id: data_object.origin_id, 
                                                    user_site_id: user.site_id,
                                                    sync_object_site_id: user.origin_id)
          parameters = ["hierarchy_entry_origin_id", "hierarchy_entry_site_id"]
          values = ["#{he.origin_id}", "#{he.site_id}"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          #call process entery
          sync_peer_log.process_entry
        end
        
        it "should remove association" do
          cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(he.id, data_object.id)
          cdoh.should be_nil
        end
      end
      
    end
    
    
    
    
    
    
    
    describe "pulling create community action" do
      before(:each) do
        load_scenario_with_caching(:communities)
        truncate_table(ActiveRecord::Base.connection, "communities", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        SpecialCollection.create(:name => "watch")
        
      
        user = User.first
        user.origin_id = user.id
        user.site_id = 1
        user.save
        
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'create')
        
        #create sync_object_type
        SyncObjectType.create(:object_type => 'Community')
        
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = user.origin_id
        @peer_log.user_site_object_id = user.site_id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Community').id
        @peer_log.sync_object_id = 80
        @peer_log.sync_object_site_id = 2
        @peer_log.save
          
        parameters = ["community_name", "community_description", "collection_origin_id", "collection_site_id"]
        values = ["comm_name", "community_description", "12", "2"]
 
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
        
        #call process entery
        @peer_log.process_entry
      end
      
      it "should create community" do
        Community.first.should_not be_nil
        Community.first.name.should == "comm_name"
        Community.first.description.should == "community_description"
        Community.first.origin_id.should == 80
        Community.first.site_id.should == 2
      end
    end
    
    describe "pulling add collection to community action" do
      before(:each) do
        load_scenario_with_caching(:communities)
        truncate_table(ActiveRecord::Base.connection, "communities", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        SpecialCollection.create(:name => "watch")
        SyncObjectAction.create_enumerated
        SyncObjectType.create_enumerated
        
        user = User.first
        user.origin_id = user.id
        user.site_id = 1
        user.save
        
        @community = Community.gen
        @community.name = "name"
        @community.description = "desc"
        @community.origin_id = @community.id
        @community.site_id = 1
        @community.save
        @community.add_member(user)
        @community.members[0].update_column(:manager, 1)
        
        @collection = Collection.gen
        @collection.origin_id = @collection.id
        @collection.site_id = 1
        @collection.save
        
        # #create sync_object_action
        # SyncObjectAction.create(:object_action => 'create')
#         
        # #create sync_object_type
        # SyncObjectType.create(:object_type => 'Community')
        
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = user.origin_id
        @peer_log.user_site_object_id = user.site_id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.add.id
        @peer_log.sync_object_type_id = SyncObjectType.community.id
        @peer_log.sync_object_id = @community.origin_id
        @peer_log.sync_object_site_id = @community.site_id
        @peer_log.save
          
        parameters = ["collection_origin_id", "collection_site_id"]
        values = [@collection.origin_id, @collection.site_id]
 
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
        
        #call process entery
        @peer_log.process_entry
      end
      
      it "should add collection to community" do
        @collection.communities.count.should == 1
      end
    end
    
    describe "pulling update community action" do
      before(:each) do
        truncate_table(ActiveRecord::Base.connection, "communities", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        SpecialCollection.create(:name => "watch")
        
        load_scenario_with_caching(:communities)
        
        user = User.first
        user.origin_id = user.id
        user.site_id = 1
        user.save
        
        community = Community.first
        community.name = "name"
        community.description = "desc"
        community.origin_id = community.id
        community.site_id = 1
        community.save
        
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'update')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'Community')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = user.origin_id
        @peer_log.user_site_object_id = user.site_id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Community').id
        @peer_log.sync_object_id = community.origin_id
        @peer_log.sync_object_site_id = community.site_id
        @peer_log.save
          
        parameters = ["community_name", "community_description", "name_change", "description_change"]
        values = ["new_name", "new_description", "1", "1"]
 
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
        #call process entery
        @peer_log.process_entry
      end
      
      it "should update community" do
        Community.first.should_not be_nil
        Community.first.name.should == "new_name"
        Community.first.description.should == "new_description"
      end
    end
    
    describe "pulling delete community action" do
      before(:each) do
        truncate_table(ActiveRecord::Base.connection, "communities", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        SpecialCollection.create(:name => "watch")
        load_scenario_with_caching(:communities)
        user = User.first
        user.origin_id = user.id
        user.site_id = 1
        user.save
        
        community = Community.first
        community.name = "name"
        community.description = "desc"
        community.origin_id = community.id
        community.site_id = 1
        community.save
        community.add_member(user)

        #create sync_object_action
        SyncObjectAction.create(:object_action => 'delete')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'Community')
        
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = user.origin_id
        @peer_log.user_site_object_id = user.site_id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('delete').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Community').id
        @peer_log.sync_object_id = community.origin_id
        @peer_log.sync_object_site_id = community.site_id
        @peer_log.save
      end
     
      it "should delete community" do
        Community.first.published.should be_true
        #call process entery
        @peer_log.process_entry
        Community.first.published.should be_false
      end
    end
    
    describe "pulling join community action" do
      before(:each) do
        truncate_table(ActiveRecord::Base.connection, "communities", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        SpecialCollection.create(:name => "watch")
        load_scenario_with_caching(:communities)
        @user = User.first
        @user.origin_id = @user.id
        @user.site_id = 1
        @user.save
        
        community = Community.first
        community.name = "name"
        community.description = "desc"
        community.origin_id = community.id
        community.site_id = 1
        community.save
        
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'join')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'Community')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = @user.origin_id
        @peer_log.user_site_object_id = @user.site_id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('join').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Community').id
        @peer_log.sync_object_id = community.origin_id
        @peer_log.sync_object_site_id = community.site_id
        @peer_log.save
      end
      
      it "should add member to community" do
        prev_members_count = Community.first.members.count
        #call process entery
        @peer_log.process_entry
        Community.first.members.count.should == prev_members_count + 1
      end
    end
   
    describe "pulling leave community action" do
      before(:each) do
        truncate_table(ActiveRecord::Base.connection, "communities", {})
        truncate_table(ActiveRecord::Base.connection, "collections", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        SpecialCollection.create(:name => "watch")
        load_scenario_with_caching(:communities)
        user = User.first
        user.origin_id = user.id
        user.site_id = 1
        user.save
        
        community = Community.first
        community.name = "name"
        community.description = "desc"
        community.origin_id = community.id
        community.site_id = 1
        community.save
        community.add_member(user)
        
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'leave')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'Community')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = user.origin_id
        @peer_log.user_site_object_id = user.site_id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('leave').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Community').id
        @peer_log.sync_object_id = community.origin_id
        @peer_log.sync_object_site_id = community.site_id
        @peer_log.save
      end
     
      it "should add member to community" do
        prev_count = Community.first.members.count
        #call process entery
        @peer_log.process_entry
        Community.first.members.count.should == prev_count - 1
      end
    end
  
  describe "user synchronization" do
    describe ".create_user" do
        
      subject(:user) {User.first}
      
      context "successful creation" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: 100, sync_object_id: 100, user_site_id: 2,
                                          sync_object_site_id: 2)
                                        
          parameters = ["language", "validation_code", "remote_ip", "username", "agreed_with_terms",
                        "collection_site_id", "collection_origin_id"]
          values = ["en", "89accf204c74d07fbdb1c2bad027946818142efb", "127.0.0.1", "user100", 
                    1, "2", "10"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
      end
    end
    
    describe ".update_user" do
        
      subject(:user) {User.gen(username: "name")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: 2)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.origin_id, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
                                        
          parameters = ["username", "bio", "remote_ip"]
          values = ["myusername", "My bio", "127.0.0.2"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
      context "failed update user not found" do
      end
    end
    
    describe ".activate_user" do
        
      subject(:user) {User.gen(active: false)}
      
      context "successful activate" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: 2)
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
      context "failed update user not found" do
      end
    end
    
    describe ".update_by_admin_user" do
        
      subject(:user) {User.gen(username: "name")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: 2)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update_by_admin.id, sync_object_type_id: SyncObjectType.user.id,
                                          user_site_object_id: user.id+1, sync_object_id: user.origin_id, user_site_id: 2,
                                          sync_object_site_id: 2)
          parameters = ["username", "bio", "remote_ip"]
          values = ["myusername", "My bio", "127.0.0.2"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
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
      context "failed update user not found" do
      end
    end
  end
  
  describe "comments synchronization" do
    describe ".create_comment" do
      
      let(:user) {User.gen} 
      let(:comment_parent) {Collection.gen(:name => "collection")}
      subject(:comment) {Comment.first}
      
      context "successful creation" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: 20, user_site_id: user.site_id,
                                          sync_object_site_id: PEER_SITE_ID)
           
          parameters = ["parent_type", "comment_parent_origin_id", "comment_parent_site_id", "body"]
          values = [ "Collection" , "#{comment_parent.origin_id}", "#{comment_parent.site_id}", "comment"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
        end
        
        it "creates new comment" do
          expect(comment).not_to be_nil          
        end
        
        it "has the correct 'body'" do
          expect(comment.body).to eq("comment")
        end
      
        it "has the correct 'user_id'" do
          expect(comment.user_id).to eq(user.id)
        end
        
        it "has the correct 'parent_id'" do
          expect(comment.parent_id).to eq(comment_parent.id)
        end
        
        it "has the correct 'parent_type'" do
          expect( comment.parent_type).to eq("Collection")
        end
      end
      #TODO handle pull failures  
      context "failed creation: user not found" do
      end
    end
    
    describe ".update_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
                                        
          parameters = ["body"]
          values = ["new comment"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "updates 'body'" do
          expect(comment.body).to eq("new comment")
        end
      end
      
      
      #TODO handle pull failures    
      context "failed update comment not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, last_updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
                                        
          parameters = ["body", "updated_at"]
          values = ["new comment", comment.last_updated_at - 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "doesn't update 'body'" do
          expect(comment.body).to eq("comment")
        end
      end
    end
    
    describe ".delete_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment")}
      
      context "successful deletion" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters = ["deleted"]
          values = ["1"]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "deletes comment" do        
          expect(comment.deleted).to eq(1)
        end
      end
      #TODO handle pull failures  
      context "failed deletion: comment not found" do
      end
    end
     
    describe ".hide_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment")}
      
      context "successful hide" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.hide.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "has correct 'visible_at'" do
          expect(comment.visible_at).to be_nil
        end
      end
      #TODO handle pull failures  
      context "failed hide: comment not found" do
      end
    end
    
    describe ".show_comment" do
        
      let(:user) {User.gen(username: "name")}
      let(:comment_parent) {Collection.gen(name: "collection")}
      subject(:comment) {Comment.gen(user_id: user.id, parent_id: comment_parent.id,
                                     parent_type: "Collection", body: "comment",
                                     visible_at: nil)}
      
      context "successful show" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters = ["visible_at"]
          values = [Time.now]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "has correct 'visible_at'" do
          expect(comment.visible_at).not_to be_nil
        end
      end
      
      # handle synchronization conflict: last update wins
      context "failed show: elder show" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collections_users", {})
          truncate_table(ActiveRecord::Base.connection, "comments", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          comment_parent.update_attributes(origin_id: comment_parent.id, site_id: PEER_SITE_ID)
          comment.update_attributes(origin_id: comment.id, site_id: PEER_SITE_ID, visible_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.show.id, sync_object_type_id: SyncObjectType.comment.id,
                                          user_site_object_id: user.origin_id, sync_object_id: comment.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: comment.site_id)
          parameters = ["visible_at"]
          values = [comment.visible_at - 2]
          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          comment.reload
        end
        
        it "doesn't update 'visible_at'" do
          expect(comment.visible_at).not_to eq(comment.visible_at - 2)
        end
      end
      
      #TODO handle pull failures  
      context "failed show comment not found" do
      end
    end
  end

    describe "pulling 'add common name' action" do
      before :each do
        truncate_all_tables
        #        truncate_table(ActiveRecord::Base.connection, "users", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        #        truncate_table(ActiveRecord::Base.connection, "names", {})
        #create user
        @user = User.gen(active: true)
        @user.update_column(:site_id, 2)
        @user.update_column(:origin_id, @user.id)
        @user.update_column(:curator_level_id, CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id)
        @user.update_column(:curator_approved, 1)

        @name = Name.gen()
        @name.update_column(:origin_id, @name.id)

        @sr = SynonymRelation.create(:id => 1)
        @sr.should_not be_nil

        tsr = TranslatedSynonymRelation.gen()
        tsr.should_not be_nil
        tsr.update_column(:label, "common name")
        tsr.update_column(:language_id, Language.first.id)
        tsr.update_column(:synonym_relation_id, @sr.id)

        relation  = SynonymRelation.find_by_translated(:label, 'common name')
        relation.should_not be_nil

        ar = AgentRole.gen()
        tar = TranslatedAgentRole.gen()
        tar.update_column(:label, "Contributor")
        tar.update_column(:agent_role_id, ar.id)
        tar.update_column(:language_id, Language.first.id)

        Visibility.create(:id => 1)
        TranslatedVisibility.gen()
        TranslatedVisibility.first.update_column(:label, "Visibile")
        TranslatedVisibility.first.update_column(:language_id, Language.first.id)
        TranslatedVisibility.first.update_column(:visibility_id, Visibility.first.id)

        @hi = Hierarchy.gen()
        @hi.update_column(:label, 'Encyclopedia of Life Contributors')

        @he = HierarchyEntry.gen()

        taxon_concept = TaxonConcept.gen()
        taxon_concept.update_column(:origin_id, taxon_concept.id)
        TaxonConceptPreferredEntry.create(:taxon_concept_id => taxon_concept.id, :hierarchy_entry_id => @he.id)
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'create')

        #create sync_object_type
        SyncObjectType.create(:object_type => 'common_name')

        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = @user.site_id
        @peer_log.user_site_object_id = @user.id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('common_name').id
        @peer_log.sync_object_id = @name.id
        @peer_log.sync_object_site_id = @name.site_id
        @peer_log.save

        #create sync_action_parameters
        parameters = ["taxon_concept_site_id", "taxon_concept_origin_id", "user_site_object_id",
          "user_site_id", "string", "language", "sync_object_site_id", "sync_object_id"]
        values     = ["#{taxon_concept.site_id}", "#{taxon_concept.origin_id}", "#{@user.origin_id}",
          "#{@user.site_id}", "#{@name.string}", "en", "#{@name.site_id}", "#{@name.id}"]
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end

      end

      it "should add common name" do
      # call process entery to execute "add common name" action
        @peer_log.process_entry
        name = Name.find_by_string("#{@name.string}")
        name.should_not be_nil
        synonym = Synonym.find_by_name_id(name.id)
        synonym.should_not be_nil
        tcn = TaxonConceptName.find_by_name_id(name.id)
        tcn.should_not be_nil
      end

      it "should ignore the already existed common name" do
        truncate_table(ActiveRecord::Base.connection, "synonyms", {})
        # make db already have a one
        synonym = Synonym.create(:name_id => @name.id, :synonym_relation_id => @sr.id, :language_id => Language.first.id,
        :hierarchy_entry_id => @he.id, :preferred => 0, :hierarchy_id => @hi.id,
        :vetted_id => 1, :site_id => @user.site_id)
        synonym_before = Synonym.all.count
        # call process entery to execute "add common name" action
        @peer_log.process_entry
        #check that there is no new synonym created
        Synonym.all.count.should_not == 0
        Synonym.all.count.should == synonym_before
      end
    end

    describe "pulling 'update common name' action" do
      before :each do
        truncate_all_tables
        #        truncate_table(ActiveRecord::Base.connection, "users", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        #        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})

        #create user
        @user = User.gen(active: true)
        @user.update_column(:site_id, 2)
        @user.update_column(:origin_id, @user.id)
        @user.update_column(:curator_level_id, CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id)
        @user.update_column(:curator_approved, 1)

        @name = Name.gen()
        @name.update_column(:origin_id, @name.id)

        SynonymRelation.create(:id => 1)
        SynonymRelation.first.should_not be_nil

        tsr = TranslatedSynonymRelation.gen()
        tsr.should_not be_nil
        tsr.update_column(:label, "common name")
        tsr.update_column(:language_id, Language.first.id)
        tsr.update_column(:synonym_relation_id, SynonymRelation.first.id)

        relation  = SynonymRelation.find_by_translated(:label, 'common name')
        relation.should_not be_nil

        ar = AgentRole.gen()
        tar = TranslatedAgentRole.gen()
        tar.update_column(:label, "Contributor")
        tar.update_column(:agent_role_id, ar.id)
        tar.update_column(:language_id, Language.first.id)

        Visibility.create(:id => 1)
        TranslatedVisibility.gen()
        TranslatedVisibility.first.update_column(:label, "Visibile")
        TranslatedVisibility.first.update_column(:language_id, Language.first.id)
        TranslatedVisibility.first.update_column(:visibility_id, Visibility.first.id)

        hi = Hierarchy.gen()
        hi.update_column(:label, 'Encyclopedia of Life Contributors')

        @taxon_concept = TaxonConcept.gen()
        @taxon_concept.update_column(:origin_id, @taxon_concept.id)
        TaxonConceptPreferredEntry.create(:taxon_concept_id => @taxon_concept.id, :hierarchy_entry_id => HierarchyEntry.gen().id)

        tcn = TaxonConceptName.gen()
        tcn.update_column(:taxon_concept_id, @taxon_concept.id)
        tcn.update_column(:name_id, @name.id)
        tcn.update_column(:preferred, 0)

        synonym = Synonym.gen
        synonym.update_column(:name_id, @name.id)
        synonym.update_column(:hierarchy_id, hi.id)
        synonym.update_column(:hierarchy_entry_id, 1)
        synonym.update_column(:synonym_relation_id, relation.id)
        synonym.update_column(:language_id, Language.first.id)
        synonym.update_column(:site_id,PEER_SITE_ID)
        synonym.update_column(:preferred,0)
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'update')

        #create sync_object_type
        SyncObjectType.create(:object_type => 'common_name')

        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = @user.site_id
        @peer_log.user_site_object_id = @user.id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('common_name').id
        @peer_log.sync_object_id = @name.id
        @peer_log.sync_object_site_id = @name.site_id
        @peer_log.save

        #create sync_action_parameters
        parameters = ["language","taxon_concept_site_id", "taxon_concept_origin_id","string"]
        values     = ["#{Language.first.iso_639_1}", "#{@taxon_concept.site_id}", "#{@taxon_concept.origin_id}","#{@name.string}"]
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
      end
      it "should update preferred column in synonym" do
        s1 = Synonym.find_by_name_id(@name.id).preferred
        #call process entery
        @peer_log.process_entry
        s2 = Synonym.find_by_name_id(@name.id).preferred.should_not == s1
      end

      it "should ignore updates for deleted names" do
        truncate_table(ActiveRecord::Base.connection, "synonyms", {})
        #call process entery
        lambda{@peer_log.process_entry}.should_not raise_exception
        Synonym.all.count.should == 0
      end
    end

    describe "pull 'delete common name' action" do
      before :each do
        truncate_all_tables
        @user = User.gen(active: true)
        @user.update_column(:site_id, 2)
        @user.update_column(:origin_id, @user.id)
        @user.update_column(:curator_level_id, CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id)
        @user.update_column(:curator_approved, 1)

        name = Name.gen()
        name.update_column(:origin_id, name.id)

        @tc = TaxonConcept.gen()
        @tc.update_column(:origin_id, @tc.id)

        @synonym = Synonym.gen()
        @synonym.update_column(:origin_id, @synonym.id)

        tcn = TaxonConceptName.gen()
        tcn.update_column(:taxon_concept_id, @tc.id)
        tcn.update_column(:name_id, name.id)
        tcn.update_column(:synonym_id, @synonym.id)

        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'delete')

        #create sync_object_type
        SyncObjectType.create(:object_type => 'common_name')

        #create peer log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = @user.site_id
        @peer_log.user_site_object_id = @user.id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_or_create_by_object_action('delete').id
        @peer_log.sync_object_type_id = SyncObjectType.find_or_create_by_object_type('common_name').id
        @peer_log.sync_object_id = @synonym.id
        @peer_log.sync_object_site_id = @synonym.site_id
        @peer_log.save

        #create sync_action_parameters
        parameters = ["taxon_concept_site_id", "taxon_concept_origin_id"]
        values     = ["#{@tc.site_id}", "#{@tc.origin_id}"]
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
        #call process entery
        @peer_log.process_entry
      end

      it "should delete synonym and taxon_concept_name" do
        TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(@synonym.id, @tc.id).should be_nil
        Synonym.find_by_id(@synonym.id).should be_nil
      end
      it "should ignore dalete actions for already deleted names" do
        truncate_table(ActiveRecord::Base.connection, "synonyms", {})
        #call process entery
        lambda{@peer_log.process_entry}.should_not raise_exception
        Synonym.all.count.should == 0
      end
    end

    describe "pull 'vet common name' action" do
      before :each do
        truncate_all_tables
        @user = User.gen(active: true)
        @user.update_column(:site_id, 2)
        @user.update_column(:origin_id, @user.id)
        @user.update_column(:curator_level_id, CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id)
        @user.update_column(:curator_approved, 1)

        @name = Name.gen()
        @name.update_column(:origin_id, @name.id)

        @tc = TaxonConcept.gen()
        @tc.update_column(:origin_id, @tc.id)

        @synonym = Synonym.gen()
        @synonym.update_column(:origin_id, @synonym.id)

        tcn = TaxonConceptName.gen()
        tcn.update_column(:taxon_concept_id, @tc.id)
        tcn.update_column(:name_id, @name.id)
        tcn.update_column(:synonym_id, @synonym.id)

        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'vet')

        #create sync_object_type
        SyncObjectType.create(:object_type => 'common_name')

        #create peer log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = @user.site_id
        @peer_log.user_site_object_id = @user.id
        @peer_log.action_taken_at = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_or_create_by_object_action('vet').id
        @peer_log.sync_object_type_id = SyncObjectType.find_or_create_by_object_type('common_name').id
        @peer_log.sync_object_id = @name.id
        @peer_log.sync_object_site_id = @name.site_id
        @peer_log.save

        #create sync_action_parameters
        parameters = ["vetted_view_order","taxon_concept_site_id", "taxon_concept_origin_id", "string"]
        values     = ["#{Vetted.first.view_order}","#{@tc.site_id}", "#{@tc.origin_id}", "#{@name.string}"]
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
        #call process entery
        @peer_log.process_entry
      end

      it "should vet common name" do
        TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(@synonym.id, @tc.id).vetted_id.should == 1
        Synonym.find_by_id(@synonym.id).vetted_id.should == 1
      end
      it "should ignore vet actions for already deleted names" do
        truncate_table(ActiveRecord::Base.connection, "synonyms", {})
        truncate_table(ActiveRecord::Base.connection, "taxon_concept_names", {})
        #call process entery
        lambda{@peer_log.process_entry}.should_not raise_exception
        Synonym.all.count.should == 0
      end

    end

 
    
    describe "collections synchronization" do
    describe ".create_collection" do
      
      let(:user) {User.gen} 
      let(:collection_item) {CollectionItem.first}
      subject(:collection) {Collection.last}
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          
          create_collection_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.collection.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: 30, user_site_id: user.site_id,
                                                            sync_object_site_id: PEER_SITE_ID)
          parameters = ["name"]
          values = ["newcollection"]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: create_collection_sync_peer_log, parameter: param,
                                             value: values[i])
          end
          
          add_collection_item_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                              sync_object_type_id: SyncObjectType.collection_item.id,
                                                              user_site_object_id: user.origin_id, 
                                                              sync_object_id: 30, user_site_id: user.site_id,
                                                              sync_object_site_id: PEER_SITE_ID)
          parameters_for_add_item = [ "item_id", "item_site_id", "collected_item_type", "collected_item_name", "base_item"]
          values_for_add_item = [ "#{user.id}", "#{user.site_id}", "User", "#{user.username}", true]

          parameters_for_add_item.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: add_collection_item_sync_peer_log, parameter: param,
                                             value: values_for_add_item[i])
          end
          create_collection_sync_peer_log.process_entry
          add_collection_item_sync_peer_log.process_entry
        end
        
        it "creates new collection" do
          expect(collection).not_to be_nil          
        end
        
        it "has the correct 'name'" do
          expect(collection.name).to eq("newcollection")
        end
      
        it "has the correct 'user_id'" do
          expect(collection.users.first.id).to eq(user.id)
        end
        
        it "creates collection item for new collection" do
          expect(collection_item).not_to be_nil 
        end
        
        it "has correct 'collected item name'" do
          expect(collection_item.name).to eq("#{user.summary_name}")
        end
        
        it "has correct 'collected item type'" do
          expect(collection_item.collected_item_type).to eq("User")
        end
        
        it "has correct 'collected item id'" do
          expect(collection_item.collected_item_id).to eq(user.id)
        end
        
        it "has correct 'collection id'" do
          expect(collection_item.collection_id).to eq(collection.id)
        end
      end
    end
    
    describe ".update_collection" do
      let(:user) {User.gen(username: "name")}
      subject(:collection) {Collection.gen(name: "collection")}
      
      context "successful update" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
                                        
          parameters = ["name", "updated_at"]
          values = ["newname", collection.updated_at + 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          collection.reload
        end
        
        it "updates 'name'" do
          expect(collection.name).to eq("newname")
        end
      end
      
      
      #TODO handle pull failures    
      context "failed update: collection not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
                                        
          parameters = ["name", "updated_at"]
          values = ["newname", collection.updated_at - 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          collection.reload
        end
        
        it "doesn't update 'name'" do
          expect(collection.name).to eq("collection")
        end
      end
    end
    
    describe ".delete_collection" do
        
      let(:user) {User.gen(username: "name")}
      subject(:collection) {Collection.gen(name: "collection")}
      
      context "successful deletion" do
        
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
         
          sync_peer_log.process_entry
          collection.reload
        end
        
        it "deletes comment" do        
          expect(collection.published).to eq(false)
        end
      end
      #TODO handle pull failures  
      context "failed deletion: collection not found" do
      end
    end
  end
  
  describe "collection items synchronization" do
    describe ".add_collection_item" do
      
      let(:user) {User.gen} 
      subject(:collection_item) {CollectionItem.first}
      let(:collection) {Collection.gen(name: "collection")}
      let(:item) {Collection.gen(name: "item")}
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters = ["collected_item_type", "collected_item_name" ,"item_id", "item_site_id", "add_item"]
          values = ["Collection", "item", "#{item.origin_id}", "#{item.site_id}", true]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
        end
        
        it "creates new collection item" do
          expect(collection_item).not_to be_nil          
        end
        
        it "has the correct 'collected item type'" do
          expect(collection_item.collected_item_type).to eq("Collection")
        end
  
        
        it "has correct 'collected item name'" do
          expect(collection_item.name).to eq("#{item.summary_name}")
        end
        
        it "has correct 'collected item id'" do
          expect(collection_item.collected_item_id).to eq(item.id)
        end
        
        it "has correct 'collection id'" do
          expect(collection_item.collection_id).to eq(collection.id)
        end
      end
    end
    
    describe ".update_collection_item" do
      let(:user) {User.gen} 
      subject(:collection_item) {CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                    collected_item_id: item.id, collection_id: collection.id)}
      let(:collection) {Collection.gen(name: "collection")}
      let(:item) {Collection.gen(name: "item")}
      let(:ref) {Ref.first}
      
      context "successful update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          
          sync_peer_log_create_ref = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.ref.id,
                                                            user_site_object_id: user.origin_id, 
                                                            user_site_id: user.site_id)
          parameters_create_ref = ["reference"]
          values_create_ref = ["reference"]

          parameters_create_ref.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log_create_ref, parameter: param,
                                             value: values_create_ref[i])
          end
          
          sync_peer_log_update_collection_item = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_update_collection_item = ["collected_item_type", "item_id", "item_site_id", "annotation", "updated_at"]
          values_update_collection_item = ["Collection", "#{item.origin_id}", "#{item.site_id}", "annotation", collection_item.updated_at + 2]

          parameters_update_collection_item.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log_update_collection_item, parameter: param,
                                             value: values_update_collection_item[i])
          end
          
          sync_peer_log_add_refs_collection_item = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_refs.id, 
                                                            sync_object_type_id: SyncObjectType.collection_item.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          parameters_add_refs_collection_item = ["collected_item_type", "item_id", "item_site_id", "references"]
          values_add_refs_collection_item = ["Collection", "#{item.origin_id}", "#{item.site_id}", "reference"]

          parameters_add_refs_collection_item.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log_add_refs_collection_item, parameter: param,
                                             value: values_add_refs_collection_item[i])
          end
          sync_peer_log_create_ref.process_entry
          sync_peer_log_update_collection_item.process_entry
          sync_peer_log_add_refs_collection_item.process_entry
          collection_item.reload
        end

        it "creates new reference" do
          expect(ref).not_to be_nil
        end
        
        it "sets 'full_reference' to 'reference'" do
          expect(ref.full_reference).to eq("reference")
        end
        
        it "sets 'user_submitted' to 'true'" do
          expect(ref.user_submitted).to eq(true)
        end
        
        it "sets 'visibility_id' to 'visible'" do
          expect(ref.visibility_id).to eq(Visibility.visible.id)
        end
        
        it "sets 'published' to '1'" do
          expect(ref.published).to eq(1)
        end
        
        it "updates 'annotation'" do
          expect(collection_item.annotation).to eq("annotation")
        end
        
        it "adds new reference to collection item" do
          collection_items_refs = collection_item.refs
          expect(collection_items_refs[0].id).to eq(ref.id)
        end
      end
      
      
      #TODO handle pull failures    
      context "failed update: collection not founde" do
      end
      
      # handle synchronization conflict: last update wins
      context "failed update: elder update" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID,
                                       updated_at: Time.now)
          
          sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.collection.id,
                                          user_site_object_id: user.origin_id, sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                          sync_object_site_id: collection.site_id)
                                        
          parameters = ["name", "updated_at"]
          values = ["newname", collection.updated_at - 2]

          parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                             value: values[i])
          end
          sync_peer_log.process_entry
          collection.reload
        end
        
        it "doesn't update 'name'" do
          expect(collection.name).to eq("collection")
        end
      end
    end
  end
  
  describe "collection jobs synchronization" do
    describe ".create_collection_job 'copy'" do
      
      let(:collection_item) { CollectionItem.where("collection_id = ? and collected_item_id = ?", empty_collection.id, item.id).first }
      let(:item) {Collection.gen(name: "item")}
      let(:empty_collection) { Collection.gen(name: "empty_collection") }
      let(:collection_job) { CollectionJob.first }
      
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user = User.gen
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection = Collection.gen(name: "collection")
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          empty_collection.update_attributes(origin_id: empty_collection.id, site_id: PEER_SITE_ID)
          empty_collection.users = [user]
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                    collected_item_id: item.id, collection_id: collection.id)
          collection_job_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.collection_job.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          collection_job_parameters = ["command", "all_items" ,"overwrite", "item_count", "unique_job_id"]
          collection_job_values = ["copy", "1", "0", "1", "1#{PEER_SITE_ID}"]

          collection_job_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: collection_job_sync_peer_log, parameter: param,
                                             value: collection_job_values[i])
          end
          
          dummy_type_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add.id, 
                                                            sync_object_type_id: SyncObjectType.dummy_type.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: empty_collection.origin_id, 
                                                            user_site_id: user.site_id,
                                                            sync_object_site_id: empty_collection.site_id)

          dummy_type_parameters = ["collected_item_type", "item_id", "item_site_id", "collected_item_name", "unique_job_id"]
          dummy_type_job_values = ["Collection", "#{item.origin_id}", "#{item.site_id}", "#{item.summary_name}", "1#{PEER_SITE_ID}"]

          dummy_type_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: dummy_type_sync_peer_log, parameter: param,
                                             value: dummy_type_job_values[i])
          end
          collection_job_sync_peer_log.process_entry
        end
        
        it "creates new collection job" do
          expect(collection_job).not_to be_nil          
        end
        
        it "has the correct 'overwrite'" do
          expect(collection_job.overwrite).to eq(false)
        end
        
        it "has correct 'item_count'" do
          expect(collection_job.item_count).to eq(1)
        end
        
        it "has correct 'all_items'" do
          expect(collection_job.all_items).to eq(true)
        end
        
        it "has correct 'command'" do
          expect(collection_job.command).to eq("copy")
        end
        
        it "has creates 'collection_jobs_collection'" do
          job_collections = collection_job.collections
          expect(job_collections[0].id).to eq(empty_collection.id)
        end
        
        it "copies collection item to 'empty_collection'" do
          expect(collection_item).not_to be_nil
        end
        
        it "has correct 'name'" do
          expect(collection_item.name).to eq("item")
        end
        
        it "has correct 'collected_item_type'" do
          expect(collection_item.collected_item_type).to eq("Collection")
        end
        
        it "has correct 'collected_item_id'" do
          expect(collection_item.collected_item_id).to eq(item.id)
        end
        
         it "has correct 'collection_id'" do
          expect(collection_item.collection_id).to eq(empty_collection.id)
        end
      end
    end
    
    describe ".create_collection_job 'remove'" do
      
      let(:collection_item) { CollectionItem.first }
      let(:item) {Collection.gen(name: "item")}
      let(:collection) { Collection.gen(name: "collection") }
      let(:collection_job) { CollectionJob.first }
      
      context "successful creation" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs", {})
          truncate_table(ActiveRecord::Base.connection, "collection_jobs_collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items_collection_jobs", {})
          
          user = User.gen
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          collection.update_attributes(origin_id: collection.id, site_id: PEER_SITE_ID)
          collection.users = [user]
          item.update_attributes(origin_id: item.id, site_id: PEER_SITE_ID)
          CollectionItem.gen(name: "#{item.name}", collected_item_type: "Collection",
                                                    collected_item_id: item.id, collection_id: collection.id)
          collection_job_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                                            sync_object_type_id: SyncObjectType.collection_job.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)
          collection_job_parameters = ["command", "all_items" ,"overwrite", "item_count", "unique_job_id"]
          collection_job_values = ["remove", "1", "0", "1", "1#{PEER_SITE_ID}"]

          collection_job_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: collection_job_sync_peer_log, parameter: param,
                                             value: collection_job_values[i])
          end
          
          dummy_type_sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.remove.id, 
                                                            sync_object_type_id: SyncObjectType.dummy_type.id,
                                                            user_site_object_id: user.origin_id, 
                                                            sync_object_id: collection.origin_id, 
                                                            user_site_id: user.site_id,
                                                            sync_object_site_id: collection.site_id)

          dummy_type_parameters = ["collected_item_type", "item_id", "item_site_id", "unique_job_id"]
          dummy_type_job_values = ["Collection", "#{item.origin_id}", "#{item.site_id}", "1#{PEER_SITE_ID}"]

          dummy_type_parameters.each_with_index do |param, i|
            lap = SyncLogActionParameter.gen(sync_peer_log: dummy_type_sync_peer_log, parameter: param,
                                             value: dummy_type_job_values[i])
          end
          collection_job_sync_peer_log.process_entry
        end
        
        it "creates new collection job" do
          expect(collection_job).not_to be_nil          
        end
        
        it "has the correct 'overwrite'" do
          expect(collection_job.overwrite).to eq(false)
        end
        
        it "has correct 'item_count'" do
          expect(collection_job.item_count).to eq(1)
        end
        
        it "has correct 'all_items'" do
          expect(collection_job.all_items).to eq(true)
        end
        
        it "has correct 'command'" do
          expect(collection_job.command).to eq("remove")
        end
        
        it "removes collection item from 'collection'" do
          expect(collection_item).to be_nil
        end
      end
    end
  end

    # test admin content pages actions synchronization
    describe "process pulling for content pages actions " do
      describe "pulling create content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
          @admin = User.gen
          @admin.grant_admin
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'create')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = 80
          @peer_log.sync_object_site_id = 2
          @peer_log.save
          
          #create sync_action_parameters
          parameters = ["parent_content_page_id", "page_name", "active", "language_id", "title", "main_content", "left_content", "meta_keywords", "meta_description", "active_translation"]
          values = ["", "test5", "1", "#{Language.first.id}", "test5", "<p>hello5</p>\r\n", "", "", "", "1"]
  
          for i in 0..parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = parameters[i]
            lap.value = values[i]
            lap.save
          end
          #call process entery
          @peer_log.process_entry
        end
  
        it "should create content_page" do
          ContentPage.count.should == 1
          content_page = ContentPage.first
          content_page.page_name.should == "test5"
          content_page.active.should == true
          TranslatedContentPage.count.should == 1
          translated_content_page = TranslatedContentPage.first
          translated_content_page.title.should == "test5"
          translated_content_page.language_id.should == Language.first.id
        end
      end
      
      describe "pulling delete content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
          @admin = User.gen
          @admin.grant_admin
          content_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"test5", "active"=>"1")
          content_page.update_column(:origin_id, content_page.id)
          content_page.update_column(:site_id, PEER_SITE_ID)
          translated_content_page = TranslatedContentPage.create({"content_page_id" => "#{content_page.id}" , 
                                                 "language_id"=>"#{Language.first.id}", 
                                                 "title"=>"test5", 
                                                 "main_content"=>"<p>hello5</p>\r\n", 
                                                 "left_content"=>"", 
                                                 "meta_keywords"=>"",
                                                 "meta_description"=>"", 
                                                 "active_translation"=>"1"})
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'delete')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event (random number)
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('delete').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = content_page.origin_id
          @peer_log.sync_object_site_id = content_page.site_id
          @peer_log.save
          
          #call process entery
          @peer_log.process_entry
        end
  
        it "should delete content_page" do
          ContentPage.count.should == 0
          TranslatedContentPage.count.should == 0
        end
      end
      
      describe "pulling move content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          @admin = User.gen
          @admin.grant_admin
          
          upper_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"upper_page", "active"=>"1", "sort_order" => 1)
          upper_page.update_column(:origin_id, upper_page.id)
          upper_page.update_column(:site_id, PEER_SITE_ID)
          lower_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"lower_page", "active"=>"1", "sort_order" => 2)
          lower_page.update_column(:origin_id, lower_page.id)
          lower_page.update_column(:site_id, PEER_SITE_ID)
          
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'swap')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event (random number)
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('swap').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = lower_page.origin_id
          @peer_log.sync_object_site_id = lower_page.site_id
          @peer_log.save
          
          #create sync_action_parameters
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = "sort_order"
          lap.value = upper_page.sort_order
          lap.save
          
          #call process entery
          @peer_log.process_entry
          
          @peer_log1 = SyncPeerLog.new
          @peer_log1.sync_event_id = 4 #pull event (random number)
          @peer_log1.user_site_id = @admin.site_id
          @peer_log1.user_site_object_id = @admin.origin_id
          @peer_log1.action_taken_at = Time.now
          @peer_log1.sync_object_action_id = SyncObjectAction.find_by_object_action('swap').id
          @peer_log1.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log1.sync_object_id = upper_page.origin_id
          @peer_log1.sync_object_site_id = upper_page.site_id
          @peer_log1.save
                    
          lap1 = SyncLogActionParameter.new
          lap1.peer_log_id = @peer_log1.id
          lap1.param_object_type_id = nil
          lap1.param_object_id = nil
          lap1.param_object_site_id = nil
          lap1.parameter = "sort_order"
          lap1.value = upper_page.sort_order + 1
          lap1.save
          
          #call process entery
          @peer_log1.process_entry
        end
  
        it "should update sort_order of content_page" do
          ContentPage.count.should == 2
          content_page = ContentPage.first
          content_page.page_name.should == "upper_page"
          content_page.active.should == true
          content_page.sort_order.should == 2
        end
      end
      
      describe "pulling update content page" do
        before(:each) do
          truncate_table(ActiveRecord::Base.connection, "content_pages", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          @admin = User.gen
          @admin.grant_admin
          content_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"old_name", "active"=>"1")
          content_page.update_column(:origin_id, content_page.id)
          content_page.update_column(:site_id, PEER_SITE_ID)
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'update')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'content_page')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 4 #pull event (random number)
          @peer_log.user_site_id = @admin.site_id
          @peer_log.user_site_object_id = @admin.origin_id
          @peer_log.action_taken_at = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('content_page').id
          @peer_log.sync_object_id = content_page.origin_id
          @peer_log.sync_object_site_id = content_page.site_id
          @peer_log.save
          
          #create sync_action_parameters
          parameters = ["parent_content_page_id", "page_name", "active"]
          values = ["", "updated_name", "1"]
  
          for i in 0..parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = parameters[i]
            lap.value = values[i]
            lap.save
          end
          #call process entery
          @peer_log.process_entry
        end
  
        it "should update page name of content_page" do
          ContentPage.count.should == 1
          content_page = ContentPage.first
          content_page.page_name.should == "updated_name"
          content_page.active.should == true
        end
      end
    end    
    
    
      # test collections actions synchronization
  describe "process pulling for data objects actions " do
    describe "pulling create data object" do
      before(:all) do
        truncate_all_tables
        load_foundation_cache
        Activity.create_enumerated
        Visibility.create_enumerated
        @toc = TocItem.gen_if_not_exists(:label => 'overview')
        @toc[:origin_id] = @toc.id
        @toc[:site_id] = PEER_SITE_ID
        @toc.save
        
        @user = User.gen        
        @user[:origin_id] = @user.id
        @user[:site_id] = PEER_SITE_ID
        @user.save
        @taxon_concept = TaxonConcept.gen
        @taxon_concept[:origin_id] = @taxon_concept.id
        @taxon_concept[:site_id] = PEER_SITE_ID
        @taxon_concept.save
        
        
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'create')
        SyncObjectAction.create(:object_action => 'add_item')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'Ref')
        SyncObjectType.create(:object_type => 'Collection')
        SyncObjectType.create(:object_type => 'data_object')
        
        # create sync peer log for creating ref
        @create_ref_peer_log = SyncPeerLog.new
        @create_ref_peer_log.sync_event_id = 5 #pull event
        @create_ref_peer_log.user_site_id = @user.site_id
        @create_ref_peer_log.user_site_object_id = @user.origin_id
        @create_ref_peer_log.action_taken_at = Time.now
        @create_ref_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @create_ref_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Ref').id
        @create_ref_peer_log.save
        
        create_ref_parameters = ["reference"]
        create_ref_values = [ "Test reference."]
        for i in 0..create_ref_parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @create_ref_peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = create_ref_parameters[i]
          lap.value = create_ref_values[i]
          lap.save
        end
        #call process entery
        @create_ref_peer_log.process_entry
        
         # create sync peer log for creating ref
        @create_data_object_peer_log = SyncPeerLog.new
        @create_data_object_peer_log.sync_event_id = 5 #pull event
        @create_data_object_peer_log.user_site_id = @user.site_id
        @create_data_object_peer_log.user_site_object_id = @user.origin_id
        @create_data_object_peer_log.action_taken_at = Time.now
        @create_data_object_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @create_data_object_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('data_object').id
        @create_data_object_peer_log.sync_object_id = 1
        @create_data_object_peer_log.sync_object_site_id = PEER_SITE_ID
        @create_data_object_peer_log.save
     
        create_data_object_parameters = ["taxon_concept_origin_id", "taxon_concept_site_id", 
          "references", "toc_id", "toc_site_id", "object_title", "description", "data_type_id",
          "language_id", "license_id"]
        create_data_object_values = ["#{@taxon_concept.origin_id}", "#{@taxon_concept.site_id}",
           "Test reference.", @toc.origin_id, @toc.site_id, "Test Article",
           "Test text", DataType.text.id.to_s, Language.english.id.to_s, License.public_domain.id.to_s]
        for i in 0..create_data_object_parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @create_data_object_peer_log.id
          lap.param_object_type_id = nil
          lap.param_object_id = nil
          lap.param_object_site_id = nil
          lap.parameter = create_data_object_parameters[i]
          lap.value = create_data_object_values[i]
          lap.save

          end
          #call process entery
          @create_ref_peer_log.process_entry

          # create sync peer log for creating ref
          @create_data_object_peer_log = SyncPeerLog.new
          @create_data_object_peer_log.sync_event_id = 5 #pull event
          @create_data_object_peer_log.user_site_id = @user.site_id
          @create_data_object_peer_log.user_site_object_id = @user.origin_id
          @create_data_object_peer_log.action_taken_at = Time.now
          @create_data_object_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
          @create_data_object_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('data_object').id
          @create_data_object_peer_log.sync_object_id = 1
          @create_data_object_peer_log.sync_object_site_id = PEER_SITE_ID
          @create_data_object_peer_log.save

          create_data_object_parameters = ["taxon_concept_origin_id", "taxon_concept_site_id",
            "references", "toc_id", "toc_site_id", "object_title", "description", "data_type_id",
            "language_id", "license_id"]
          create_data_object_values = ["#{@taxon_concept.origin_id}", "#{@taxon_concept.site_id}",
            "Test reference.", @toc.origin_id, @toc.site_id, "Test Article",
            "Test text", DataType.text.id.to_s, Language.english.id.to_s, License.public_domain.id.to_s]
          for i in 0..create_data_object_parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @create_data_object_peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = create_data_object_parameters[i]
            lap.value = create_data_object_values[i]
            lap.save
          end
          #call process entery
          @create_data_object_peer_log.process_entry

          # create sync peer log for creating ref
          @create_collection_item_peer_log = SyncPeerLog.new
          @create_collection_item_peer_log.sync_event_id = 5 #pull event
          @create_collection_item_peer_log.user_site_id = @user.site_id
          @create_collection_item_peer_log.user_site_object_id = @user.origin_id
          @create_collection_item_peer_log.action_taken_at = Time.now
          @create_collection_item_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('add_item').id
          @create_collection_item_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Collection').id
          @create_collection_item_peer_log.sync_object_id = @user.watch_collection.origin_id
          @create_collection_item_peer_log.sync_object_site_id = PEER_SITE_ID
          @create_collection_item_peer_log.save

          create_collection_item_parameters = ["item_id", "item_site_id", "collected_item_type", "collected_item_name"]
          create_collection_item_values = ["1", PEER_SITE_ID, "DataObject", "Test Article"]
          for i in 0..create_collection_item_parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @create_collection_item_peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = create_collection_item_parameters[i]
            lap.value = create_collection_item_values[i]
            lap.save
          end
          #call process entery
          @create_collection_item_peer_log.process_entry

        end

        it "should create data object" do
          ref = Ref.first
          ref.full_reference.should == "Test reference."
          ref.user_submitted.should == true
          ref.visibility_id.should == Visibility.visible.id
          ref.published.should == 1

          data_obj = DataObject.find(2)
          data_obj.object_title.should == "Test Article"
          data_obj.description.should == "Test text"
          data_obj.license_id.should == License.public_domain.id

          user_data_obj = UsersDataObject.first
          user_data_obj.user_id.should == @user.id
          data_obj.toc_items[0].id.should == TocItem.overview.id

          data_obj_ref = data_obj.refs[0]
          data_obj_ref.id.should == ref.id

          data_obj_taxon_concept = DataObjectsTaxonConcept.first
          data_obj_taxon_concept.taxon_concept_id.should == @taxon_concept.id
          data_obj_taxon_concept.data_object_id.should == data_obj.id

          col_item = CollectionItem.first
          col_item.collected_item_type.should == "DataObject"
          col_item.name.should == "Test Article"
          col_item.collected_item_id.should == data_obj.id
          col_item.collection_id.should == @user.watch_collection.id
        end
      end

      describe "pulling update data object" do
        before(:all) do
          truncate_all_tables
          load_foundation_cache
          Activity.create_enumerated
          Visibility.create_enumerated
          @toc = TocItem.gen_if_not_exists(:label => 'overview')
          @toc[:origin_id] = @toc.id
          @toc[:site_id] = PEER_SITE_ID
          @toc.save

          @user = User.gen
          @user[:origin_id] = @user.id
          @user[:site_id] = PEER_SITE_ID
          @user.save
          @taxon_concept = TaxonConcept.gen
          @taxon_concept[:origin_id] = @taxon_concept.id
          @taxon_concept[:site_id] = PEER_SITE_ID
          @taxon_concept.save
          @data_object = @taxon_concept.add_user_submitted_text(:user => @user)
          @data_object[:origin_id] = @data_object.id
          @data_object[:site_id] = PEER_SITE_ID
          @data_object.save
          @data_object.refs << Ref.new(full_reference: "Test reference", user_submitted: true, published: 1,
                                         visibility: Visibility.visible)

          #create sync_object_action
          SyncObjectAction.create(:object_action => 'create')
          SyncObjectAction.create(:object_action => 'update')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'Ref')
          SyncObjectType.create(:object_type => 'data_object')

          # create sync peer log for creating ref
          @create_ref_peer_log = SyncPeerLog.new
          @create_ref_peer_log.sync_event_id = 5 #pull event
          @create_ref_peer_log.user_site_id = @user.site_id
          @create_ref_peer_log.user_site_object_id = @user.origin_id
          @create_ref_peer_log.action_taken_at = Time.now
          @create_ref_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
          @create_ref_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Ref').id
          @create_ref_peer_log.save

          create_ref_parameters = ["reference"]
          create_ref_values = [ "Test reference."]
          for i in 0..create_ref_parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @create_ref_peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = create_ref_parameters[i]
            lap.value = create_ref_values[i]
            lap.save
          end
          #call process entery
          @create_ref_peer_log.process_entry

          # create sync peer log for creating ref
          @update_data_object_peer_log = SyncPeerLog.new
          @update_data_object_peer_log.sync_event_id = 5 #pull event
          @update_data_object_peer_log.user_site_id = @user.site_id
          @update_data_object_peer_log.user_site_object_id = @user.origin_id
          @update_data_object_peer_log.action_taken_at = Time.now
          @update_data_object_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
          @update_data_object_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('data_object').id
          @update_data_object_peer_log.sync_object_id = @data_object.origin_id
          @update_data_object_peer_log.sync_object_site_id = @data_object.site_id
          @update_data_object_peer_log.save

          update_data_object_parameters = ["new_revision_origin_id", "new_revision_site_id",
            "references", "toc_id", "toc_site_id", "object_title", "description", "data_type_id",
            "language_id", "license_id"]
          update_data_object_values = [3, PEER_SITE_ID,
            "Test reference.", @toc.origin_id, @toc.site_id, "Test Article",
            "Test text", DataType.text.id.to_s, Language.english.id.to_s, License.public_domain.id.to_s]
          for i in 0..update_data_object_parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @update_data_object_peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = update_data_object_parameters[i]
            lap.value = update_data_object_values[i]
            lap.save
          end
          #call process entery
          @update_data_object_peer_log.process_entry
        end

        it "should update data object" do
          ref = Ref.find(2)
          ref.full_reference.should == "Test reference."
          ref.user_submitted.should == true
          ref.visibility_id.should == Visibility.visible.id
          ref.published.should == 1

          data_obj = DataObject.find(3)
          data_obj.object_title.should == "Test Article"
          data_obj.description.should == "Test text"
          data_obj.license_id.should == License.public_domain.id

          user_data_obj = UsersDataObject.find(2)
          user_data_obj.user_id.should == @user.id
          data_obj.toc_items[0].id.should == TocItem.overview.id

          data_obj_ref = data_obj.refs[0]
          data_obj_ref.id.should == ref.id
          
          data_obj_taxon_concept = DataObjectsTaxonConcept.find(:first, :conditions => "data_object_id = 3 and taxon_concept_id = #{@taxon_concept.id}")
          data_obj_taxon_concept.should_not be_nil
        end
      end
      
      describe "pulling rate data object" do
        before(:all) do
          truncate_all_tables
          load_foundation_cache
          Activity.create_enumerated
          Visibility.create_enumerated
          @toc = TocItem.gen_if_not_exists(:label => 'overview')
          @toc[:origin_id] = @toc.id
          @toc[:site_id] = PEER_SITE_ID
          @toc.save

          @user = User.gen
          @user[:origin_id] = @user.id
          @user[:site_id] = PEER_SITE_ID
          @user.save
          @taxon_concept = TaxonConcept.gen
          @taxon_concept[:origin_id] = @taxon_concept.id
          @taxon_concept[:site_id] = PEER_SITE_ID
          @taxon_concept.save
          @data_object = @taxon_concept.add_user_submitted_text(:user => @user)
          @data_object[:origin_id] = @data_object.id
          @data_object[:site_id] = PEER_SITE_ID
          @data_object.save
          @data_object.refs << Ref.new(full_reference: "Test reference", user_submitted: true, published: 1,
                                         visibility: Visibility.visible)

          #create sync_object_action
          SyncObjectAction.create(:object_action => 'rate')
          
          #create sync_object_type
          SyncObjectType.create(:object_type => 'data_object')

          # create sync peer log for rating data object
          @rate_data_object_peer_log = SyncPeerLog.new
          @rate_data_object_peer_log.sync_event_id = 5 #pull event
          @rate_data_object_peer_log.user_site_id = @user.site_id
          @rate_data_object_peer_log.user_site_object_id = @user.origin_id
          @rate_data_object_peer_log.action_taken_at = Time.now
          @rate_data_object_peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('rate').id
          @rate_data_object_peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('data_object').id
          @rate_data_object_peer_log.sync_object_id = @data_object.origin_id
          @rate_data_object_peer_log.sync_object_site_id = @data_object.site_id
          @rate_data_object_peer_log.save

          rate_data_object_parameters = ["stars"]
          rate_data_object_values = [3]
          
          for i in 0..rate_data_object_parameters.length-1
            lap = SyncLogActionParameter.new
            lap.peer_log_id = @rate_data_object_peer_log.id
            lap.param_object_type_id = nil
            lap.param_object_id = nil
            lap.param_object_site_id = nil
            lap.parameter = rate_data_object_parameters[i]
            lap.value = rate_data_object_values[i]
            lap.save
          end
          #call process entery
          @rate_data_object_peer_log.process_entry
        end

        it "should rate data object" do          
          data_obj = DataObject.find(2)
          data_obj.data_rating.should == 3
          
          user_data_obj_rate = UsersDataObjectsRating.first
          user_data_obj_rate.user_id.should == @user.id
          user_data_obj_rate.data_object_guid.should == @data_object.guid
          user_data_obj_rate.rating.should == 3         
        end
      end
    end
    
    describe "process pulling for translated content pages actions " do
      describe ".add_translation_content_page" do
        
        let(:user) {User.gen}
        let(:content_page) {ContentPage.gen}
        subject(:translated_content_page) {TranslatedContentPage.first}
        let(:language) {Language.english}
        
        context "successful creation" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
                                          
            parameters = ["language_id", "title", "main_content", "left_content",
                          "meta_keywords", "meta_description", "active_translation"]
            values = ["#{language.id}" , "title", "main_content", "left_content",
                      "meta_keywords", "meta_description", "1"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
          end
          
          it "new translation will be added to content page" do
            expect(translated_content_page).not_to be_nil          
          end
          
          it "translated content page should respond to 'language'" do
            expect(translated_content_page.language_id).to eq(language.id)
          end
        
          it "translated content page should respond to 'title'" do
            expect(translated_content_page.title).to eq("title")
          end
          
          it "translated content page should respond to 'main_content'" do
            expect(translated_content_page.main_content).to eq("main_content")
          end
          
          it "translated content page should respond to 'left_content'" do
            expect(translated_content_page.left_content).to eq("left_content")
          end
          
          it "translated content page should respond to 'meta_keywords'" do
            expect(translated_content_page.meta_keywords).to eq("meta_keywords")
          end
          
          it "translated content page should respond to 'meta_description'" do
            expect(translated_content_page.meta_description).to eq("meta_description")
          end
          
          it "translated content page should respond to 'active_translation'" do
            expect(translated_content_page.active_translation).to eq(1)
          end
          
          it "update content page" do
            expect(content_page.last_update_user_id).to eq(user.id)
          end
        end
        
        context "failed creation: content page not found" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.add_translation.id, sync_object_type_id: SyncObjectType.content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
            
            parameters = ["language_id", "title", "main_content", "left_content",
                          "meta_keywords", "meta_description", "active_translation"]
            values = ["#{language.id}" , "title", "main_content", "left_content",
                      "meta_keywords", "meta_description", "1"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
          end
          
          it "doesn't create translated content page" do
            expect(translated_content_page).to be_nil
          end
        end
       end
      
      describe ".update_translated_content_page" do
        
        let(:content_page) {ContentPage.gen}
        subject(:translated_content_page) {TranslatedContentPage.gen(content_page: content_page, language: Language.english)} 
        
        context "successful update" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user = User.gen
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
            
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
                                          
            parameters = ["language_id", "title", "main_content", "left_content",
                          "meta_keywords", "meta_description", "active_translation"]
            values = ["#{translated_content_page.language.id}" , "new title", "main_content", "left_content",
                      "meta_keywords", "meta_description", "1"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
            translated_content_page.reload
          end
        
          it "updates title of translated content page" do
            expect(translated_content_page.title).to eq("new title")
          end
          
          it "updates main_content of translated content page" do
            expect(translated_content_page.main_content).to eq("main_content")
          end
          
          it "updates left_content of translated content page" do
            expect(translated_content_page.left_content).to eq("left_content")
          end
          
          it "updates meta_keywords of translated content page" do
            expect(translated_content_page.meta_keywords).to eq("meta_keywords")
          end
          
          it "updates meta_description of translated content page" do
            expect(translated_content_page.meta_description).to eq("meta_description")
          end
        end
       #TODO handle pull failures  
        context "failed update: translated content page not found" do
        end
       end
      end
      
      describe ".delete_translated_content_page" do
        
        context "successful deletion" do
          
          before(:all) do
            truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
            truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
            truncate_table(ActiveRecord::Base.connection, "content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "translated_content_pages", {})
            truncate_table(ActiveRecord::Base.connection, "users", {})
            
            user = User.gen
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            content_page = ContentPage.gen
            content_page.update_attributes(origin_id: content_page.id, site_id: PEER_SITE_ID)
            translated_content_page = TranslatedContentPage.gen(content_page: content_page, language: Language.english)
            sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, sync_object_type_id: SyncObjectType.translated_content_page.id,
                                          user_site_object_id: user.origin_id, sync_object_id: content_page.id)
            
            parameters = ["language_id"]
            values = ["#{translated_content_page.language.id}"]
  
            parameters.each_with_index do |param, i|
              lap = SyncLogActionParameter.gen(sync_peer_log: sync_peer_log, parameter: param,
                                               value: values[i])
            end
            sync_peer_log.process_entry
          end
        
          it "delets translated content page" do
            expect(TranslatedContentPage.all).to be_blank
          end
          
          it "archives deleted translated content page" do
            expect(TranslatedContentPageArchive.first.title).to eq("Test Content Page")
          end
        end
       #TODO handle pull failures  
        context "failed deletion translated content page not found" do
        end
       end
    
  end
end