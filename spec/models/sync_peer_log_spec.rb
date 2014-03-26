require "spec_helper"

describe SyncPeerLog do

  describe "process pull" do
    describe "pulling create user action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})

        @prev_count = EOL::GlobalStatistics.solr_count('User')
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'create')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'User')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = 2
        @peer_log.user_site_object_id = 80
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('User').id
        @peer_log.sync_object_id = 80
        @peer_log.sync_object_site_id = 2
        @peer_log.save
        #create sync_action_parameters

        parameters = ["language", "validation_code", "remote_ip", "origin_id", "site_id", "username", "agreed_with_terms"]
        values = ["en", "89accf204c74d07fbdb1c2bad027946818142efb", "127.0.0.1", "80", "2", "user100", "1"]

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

      it "should create user" do
        User.count.should == 1
        user = User.first
        #user must not have a password or an email
        user.email.should be_nil
        user.hashed_password.should be_nil

        user.username.should == "user100"
        user.language_id.should == Language.find_by_iso_639_1("en").id
        user.validation_code.should ==  "89accf204c74d07fbdb1c2bad027946818142efb"
        user.remote_ip.should == "127.0.0.1"
        user.origin_id.should == 80
        user.site_id.should == 2
        user.username.should == "user100"
        user.agreed_with_terms == 1
      end

      it "should update global statistics" do
        Rails.cache.read(EOL::GlobalStatistics.key_for_type("users")).should == @prev_count + 1
      end

    end

    describe "pulling update user action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})
        user = User.create(:origin_id => 85, :site_id => 2, :username => "name")
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'update')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'User')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 5 #pull event
        @peer_log.user_site_id = 2
        @peer_log.user_site_object_id = user.origin_id
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('User').id
        @peer_log.sync_object_id = user.origin_id
        @peer_log.sync_object_site_id = 2
        @peer_log.save
        #create sync_action_parameters
        parameters = ["username", "bio", "remote_ip", "origin_id", "site_id", "logo_cache_url",
                      "logo_file_name", "logo_content_type", "logo_file_size", "base_url"]
        values = ["myusername", "My bio", "127.0.0.2", "85", "2", "201403200876152", "shopcandles006.JPG", "image/jpeg", "322392", "#{$CONTENT_SERVER}content/"]
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

      it "should update user" do
        user = User.first
        #user must not have a password or an email
        user.email.should be_nil
        user.hashed_password.should be_nil

        user.username.should == "myusername"
        user.bio.should == "My bio"
        files = Dir.glob("#{Rails.root}/public#{$LOGO_UPLOAD_PATH}users_1.JPG")
      end

    end

    describe "pulling update user by admiin action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})

        user = User.create(:origin_id => 82, :site_id => 2, :username => "name2")

        #create sync_object_action
        SyncObjectAction.create(:object_action => 'update_by_admin')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'User')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 6 #pull event
        @peer_log.user_site_id = 2
        @peer_log.user_site_object_id = 81
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update_by_admin').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('User').id
        @peer_log.sync_object_id = user.origin_id
        @peer_log.sync_object_site_id = 2
        @peer_log.save
        #create sync_action_parameters

        parameters = ["username", "bio", "remote_ip", "origin_id", "site_id"]
        values = ["myusername", "My bio", "127.0.0.2", "82", "2"]

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

      it "should update user" do
        user = User.first
        #user must not have a password or an email
        user.email.should be_nil
        user.hashed_password.should be_nil

        user.username.should == "myusername"
        user.bio.should == "My bio"
      end

    end

    describe "pulling activate user action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})

        #create user to be activated laterly
        @user = User.gen(active: false)
        @user.site_id = 2
        @user.origin_id = @user.id
        @user.save

        #create sync_object_action
        SyncObjectAction.create(:object_action => 'activate')

        #create sync_object_type
        SyncObjectType.create(:object_type => 'User')

        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = 2
        @peer_log.user_site_object_id = @user.id
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('activate').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('User').id
        @peer_log.sync_object_id = @user.id
        @peer_log.sync_object_site_id = 2
        @peer_log.save

        #create sync_action_parameters
        parameters = ["origin_id", "site_id"]
        values     = ["#{@user.origin_id}", "2"]

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

      it "should activate user" do
        user = User.where(:site_id => @user.site_id, :origin_id => @user.origin_id)
        if user && user.count
          user = user[0]
          user.active.should be_true
          user.validation_code.should be_nil
        end
      end

      it "should create a collection"
      it "should add user to index"
    end
    
    describe "pulling 'add common name' action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        
        #create user 
        @user = User.gen(active: true)
        @user.update_column(:site_id, 2)
        @user.update_column(:origin_id, @user.id)
        @user.update_column(:curator_level_id, CuratorLevel.find_or_create_by_id(1, :label => "master", :rating_weight => 1).id)
        @user.update_column(:curator_approved, 1)
        
        name = Name.gen()
        name.update_column(:origin_id, name.id)
        
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

        taxon_concept = TaxonConcept.gen()
        taxon_concept.update_column(:origin_id, taxon_concept.id)
        TaxonConceptPreferredEntry.create(:taxon_concept_id => taxon_concept.id, :hierarchy_entry_id => HierarchyEntry.gen().id)
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'create')
        
        #create sync_object_type
        SyncObjectType.create(:object_type => 'common_name')
        
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 4 #pull event
        @peer_log.user_site_id = @user.site_id
        @peer_log.user_site_object_id = @user.id
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('common_name').id
        @peer_log.sync_object_id = name.id
        @peer_log.sync_object_site_id = name.site_id
        @peer_log.save
        
        #create sync_action_parameters
        parameters = ["taxon_concept_site_id", "taxon_concept_origin_id", "user_site_object_id",
                      "user_site_id", "string", "language", "sync_object_site_id", "sync_object_id"]
        values     = ["#{taxon_concept.site_id}", "#{taxon_concept.origin_id}", "#{@user.origin_id}",
                      "#{@user.site_id}", "snake", "en", "#{name.site_id}", "#{name.id}"]
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
      
      it "should add common name" do
        name = Name.find_by_string("snake")
        name.should_not be_nil
        synonym = Synonym.find_by_name_id(name.id)
        synonym.should_not be_nil
        tcn = TaxonConceptName.find_by_name_id(name.id)
        tcn.should_not be_nil
      end
    end
    
    describe "pulling 'update common name' action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "users", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        
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

        taxon_concept = TaxonConcept.gen()
        taxon_concept.update_column(:origin_id, taxon_concept.id)
        TaxonConceptPreferredEntry.create(:taxon_concept_id => taxon_concept.id, :hierarchy_entry_id => HierarchyEntry.gen().id)
        
        tcn = TaxonConceptName.gen()
        tcn.update_column(:taxon_concept_id, taxon_concept.id)
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
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('common_name').id
        @peer_log.sync_object_id = @name.id
        @peer_log.sync_object_site_id = @name.site_id
        @peer_log.save
        
        #create sync_action_parameters
        parameters = ["language","taxon_concept_site_id", "taxon_concept_origin_id"]
        values     = ["#{Language.first.iso_639_1}", "#{taxon_concept.site_id}", "#{taxon_concept.origin_id}"]
        for i in 0..parameters.length-1
          lap = SyncLogActionParameter.new
          lap.peer_log_id = @peer_log.id
          lap.parameter = parameters[i]
          lap.value = values[i]
          lap.save
        end
      end
      it "should update preferred column in common name" do
        s1 = Synonym.find_by_name_id(@name.id).preferred
        #call process entery
        @peer_log.process_entry
        s2 = Synonym.find_by_name_id(@name.id).preferred.should_not == s1
      end
    end
    
    describe "pull 'delete common name' action" do
      before :all do
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
        @peer_log.action_taken_at_time = Time.now
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
    end
    
    describe "pull 'vet common name' action" do
     before :all do
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
       @peer_log.action_taken_at_time = Time.now
       @peer_log.sync_object_action_id = SyncObjectAction.find_or_create_by_object_action('vet').id
       @peer_log.sync_object_type_id = SyncObjectType.find_or_create_by_object_type('common_name').id
       @peer_log.sync_object_id = @name.id
       @peer_log.sync_object_site_id = @name.site_id
       @peer_log.save
       
       #create sync_action_parameters
       parameters = ["vetted_view_order","taxon_concept_site_id", "taxon_concept_origin_id"]
       values     = ["#{Vetted.first.view_order}","#{@tc.site_id}", "#{@tc.origin_id}"]
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
   end
    
    describe "pulling becoming curator action" do
      before(:all) do
        truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
        truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        truncate_table(ActiveRecord::Base.connection, "users", {})

        CuratorLevel.create(:id => 1, :label => "Master Curator", :rating_weight => 1)
        CuratorLevel.create(:id => 2, :label => "Full Curator", :rating_weight => 1)
        CuratorLevel.create(:id => 3, :label => "Assistant Curator", :rating_weight => 1)

        user = User.create(:origin_id => 84, :site_id => 2, :username => "name3",
        :credentials => "Faculty, staff, or graduate student status in a relevant university or college departme",
        :curator_scope => "Rodents of Borneo")
        #create sync_object_action
        SyncObjectAction.create(:object_action => 'update_by_admin')
        #create sync_object_type
        SyncObjectType.create(:object_type => 'User')
        #create sync_peer_log
        @peer_log = SyncPeerLog.new
        @peer_log.sync_event_id = 7 #pull event
        @peer_log.user_site_id = 2
        @peer_log.user_site_object_id = 83
        @peer_log.action_taken_at_time = Time.now
        @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update_by_admin').id
        @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('User').id
        @peer_log.sync_object_id = user.origin_id
        @peer_log.sync_object_site_id = 2
        @peer_log.save
        #create sync_action_parameters

        parameters = ["username", "given_name", "family_name" , "remote_ip", "origin_id", "site_id", "curator_approved", "curator_level_id", "credentials", "curator_scope"]
        values = ["myusername", "user" ,"family","127.0.0.2", "84", "2", "1", "2", "Faculty, staff, or graduate student status in a relevant university or college departme", "Rodents of Borneo"]

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

      it "should update user" do
        user = User.first
        #user must not have a password or an email
        user.email.should be_nil
        user.hashed_password.should be_nil

        #user.curator_verdict_by_id.should == "83"
        user.curator_approved.should == true
        user.curator_level_id.should == 2

      end

    end

    # test collections actions synchronization
    describe "process pulling for collections actions " do
      describe "pulling create collection" do
        before(:all) do
          # prepare database for testing
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})
          
                    
          @user = User.create(:origin_id => 86, :site_id => 2, :username => "username")
          @last_collection_count = EOL::GlobalStatistics.solr_count('Collection')
        
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'create')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'Collection')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 5 #pull event
          @peer_log.user_site_id = 2
          @peer_log.user_site_object_id = @user.origin_id
          @peer_log.action_taken_at_time = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('create').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Collection').id
          @peer_log.sync_object_id = 30
          @peer_log.sync_object_site_id = 2
          @peer_log.save
          
          #create sync_action_parameters
          parameters = ["name",  "item_origin_id", "item_site_id", "item_type", "item_name"]
          values = ["newcollection", "86", "2", "User", "#{@user.username}"]

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

        it "should create collection" do
          # test creating collection
          collection = Collection.first
          collection.name.should == "newcollection"
          
          # test creating user collection record
          user_collection = collection.users.first
          user_collection.id.should == @user.id
          
          #test creating collection item
          collection_item = CollectionItem.first
          collection_item.name.should == "#{@user.username}"
          collection_item.collected_item_type.should == "User"
          collection_item.collected_item_id.should == "#{@user.id}".to_i
          collection_item.collection_id.should == "#{collection.id}".to_i

         Rails.cache.read(EOL::GlobalStatistics.key_for_type("collections")).should == @last_collection_count + 2
          
          
        end
      end
      
      describe "pulling update collection" do
        before(:all) do
          truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
          truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
          truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
          truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
          truncate_table(ActiveRecord::Base.connection, "users", {})
          truncate_table(ActiveRecord::Base.connection, "collections", {})
          truncate_table(ActiveRecord::Base.connection, "collection_items", {})

          @user = User.create(:origin_id => 86, :site_id => 2, :username => "username")
          @collection = Collection.create(:origin_id => 30, :site_id => 2, :name => "name")

        
          #create sync_object_action
          SyncObjectAction.create(:object_action => 'update')
          #create sync_object_type
          SyncObjectType.create(:object_type => 'Collection')
          #create sync_peer_log
          @peer_log = SyncPeerLog.new
          @peer_log.sync_event_id = 5 #pull event
          @peer_log.user_site_id = 2
          @peer_log.user_site_object_id = @user.origin_id
          @peer_log.action_taken_at_time = Time.now
          @peer_log.sync_object_action_id = SyncObjectAction.find_by_object_action('update').id
          @peer_log.sync_object_type_id = SyncObjectType.find_by_object_type('Collection').id
          @peer_log.sync_object_id = @collection.origin_id
          @peer_log.sync_object_site_id = 2
          @peer_log.save
          #create sync_action_parameters

          parameters = ["name"]
          values = ["newname"]

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

        it "should update user" do
          # test updating collection
          collection = Collection.first
          collection.name.should == "newname"        
          
        end
      end
    end

  end
end