require File.dirname(__FILE__) + '/../../spec_helper'

describe Taxa::NamesController do

  before(:all) do
    truncate_all_tables
    load_scenario_with_caching :testy
    @testy = EOL::TestInfo.load('testy')
  end

  shared_examples_for 'taxa/names controller' do
    it 'should instantiate section for assistive header' do
      assigns[:assistive_section_header].should be_a(String)
    end
    it 'should instantiate the taxon concept' do
      assigns[:taxon_concept].should == @testy[:taxon_concept]
    end
  end


  describe 'GET related_names' do # default related names
    before :each do
      get :related_names, :taxon_id => @testy[:taxon_concept].id.to_i
    end
    it_should_behave_like 'taxa/names controller'
    it 'should instantiate related names' do
      assigns[:related_names].should be_a(Hash)
      assigns[:related_names]['parents'].should be_a(Array)
      assigns[:related_names]['children'].should be_a(Array)
    end
  end

  describe "DELETE names" do
    before :each do
      session[:user_id] = @testy[:curator].id
    end
    it "should prepare data for syncronization" do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        
      tcn = TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(@testy[:synonym]["synonym"].id,  @testy[:taxon_concept].id.to_i)
      tcn.should_not be_nil
      get :delete, :taxon_id => @testy[:taxon_concept].id.to_i, :synonym_id => @testy[:synonym]["synonym"].id
      tcn = TaxonConceptName.find_by_synonym_id_and_taxon_concept_id(@testy[:synonym]["synonym"].id,  @testy[:taxon_concept].id.to_i)
      tcn.should be_nil
      
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "common_name"
     
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "delete"
     
      # check peer logs
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.sync_object_id.should == @testy[:synonym]["synonym"].origin_id
      peer_log.sync_object_site_id.should == @testy[:synonym]["synonym"].site_id
     
      # check log action parameters
      taxon_concept_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_origin_id")
      taxon_concept_origin_id_parameter[0][:value].should ==  @testy[:taxon_concept].origin_id
           
      taxon_concept_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_site_id")
      taxon_concept_site_id_parameter[0][:value].should ==  @testy[:taxon_concept].site_id.to_s
    end
  end
  
  describe 'POST names' do
    before :each do
      session[:user_id] = @testy[:curator].id
      @approved_languages = Language.approved_languages.collect{|l| l.id}
    end
    it 'should add a new common name in approved languages' do
      approved_language_id = @approved_languages.first
      post :create, :name => { :synonym => { :language_id => approved_language_id }, :string => "snake" }, 
                    :commit_add_common_name => "Add name", :taxon_id => @testy[:taxon_concept].id.to_i
      name = Name.find_by_string("snake").should be_true
      TaxonConceptName.find_by_name_id_and_language_id(Name.find_by_string("snake").id, approved_language_id)
      response.should redirect_to(common_names_taxon_names_path(@testy[:taxon_concept].id.to_i))
    end
    it 'should add a new common name in non-approved languages' do
      non_approved_language_id = Language.find(:all, :conditions => ["id NOT IN (?)", @approved_languages]).first.id
      post :create, :name => { :synonym => { :language_id => non_approved_language_id }, :string => "nag" }, 
                    :commit_add_common_name => "Add name", :taxon_id => @testy[:taxon_concept].id.to_i
      name = Name.find_by_string("nag").should be_true
      TaxonConceptName.find_by_name_id_and_language_id(Name.find_by_string("nag").id, non_approved_language_id)
      response.should redirect_to(common_names_taxon_names_path(@testy[:taxon_concept].id.to_i))
    end
    
    it 'should prepare data when update common names for syncronization' do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        
      approved_language_id = @approved_languages.first
      post :update, :preferred_name_id => @testy[:name].id, :language_id => approved_language_id, :taxon_id => @testy[:taxon_concept].id.to_i
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "common_name"
      
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "update"
      
      # check peer logs
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.sync_object_id.should == @testy[:name].origin_id
      peer_log.sync_object_site_id.should == @testy[:name].site_id
      
      # check log action parameters
      taxon_concept_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_origin_id")
      taxon_concept_origin_id_parameter[0][:value].should ==  @testy[:taxon_concept].origin_id
      
      taxon_concept_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_site_id")
      taxon_concept_site_id_parameter[0][:value].should ==  @testy[:taxon_concept].site_id.to_s
      
      language_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "language")
      language_parameter[0][:value].should ==   @approved_languages.first.to_s
    end
    
    it 'should prepare data when add common names for syncronization' do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        
      approved_language_id = @approved_languages.first
      post :create, :name => { :synonym => { :language_id => approved_language_id }, :string => "snake" }, 
                    :commit_add_common_name => "Add name", :taxon_id => @testy[:taxon_concept].id.to_i
      
      name = Name.find_by_string("snake")
      name.should_not be_nil
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "common_name"
      
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "create"
      
      # check peer logs
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.sync_object_id.should == name.origin_id
      peer_log.sync_object_site_id.should == name.site_id
      
      # check log action parameters
      taxon_concept_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_origin_id")
      taxon_concept_origin_id_parameter[0][:value].should ==  @testy[:taxon_concept].origin_id
      
      taxon_concept_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_site_id")
      taxon_concept_site_id_parameter[0][:value].should ==  @testy[:taxon_concept].site_id.to_s
      
      string_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "string")
      string_parameter[0][:value].should ==  "snake" 
    end
  end

  describe "vet common names" do
    before :each do
      session[:user_id] = @testy[:curator].id
      @approved_languages = Language.approved_languages.collect{|l| l.id}
    end
    
    it 'should prepare data when vet common names for syncronization' do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
        
      approved_language_id = @approved_languages.first
      v = Vetted.first
      get :vet_common_name, :id => @testy[:name].id, :language_id => approved_language_id, :vetted_id => Vetted.first.id, :taxon_id => @testy[:taxon_concept].id.to_i
      
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "common_name"
      
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "vet"
      
      # check peer logs
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.sync_object_id.should == @testy[:name].origin_id
      peer_log.sync_object_site_id.should == @testy[:name].site_id
      
      # check log action parameters
      taxon_concept_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_origin_id")
      taxon_concept_origin_id_parameter[0][:value].should == @testy[:taxon_concept].origin_id
      
      taxon_concept_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "taxon_concept_site_id")
      taxon_concept_site_id_parameter[0][:value].should == @testy[:taxon_concept].site_id.to_s
      
      language_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "language")
      language_parameter[0][:value].should == @approved_languages.first.to_s
        
      vetted_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "vetted_view_order")
      vetted_parameter[0][:value].should == v.view_order.to_s

    end
  end
  describe 'GET common_names' do
    before :each do
      get :common_names, :taxon_id => @testy[:taxon_concept].id.to_i
    end
    it_should_behave_like 'taxa/names controller'
    it 'should instantiate common names' do
      assigns[:common_names].should be_a(Array)
      assigns[:common_names].first.should be_a(EOL::CommonNameDisplay)
    end
  end

  describe 'GET synonyms' do
    before :each do
      get :synonyms, :taxon_id => @testy[:taxon_concept].id.to_i
    end
    it_should_behave_like 'taxa/names controller'
    it 'should preload synonym associations' do
      assigns[:taxon_concept].published_hierarchy_entries.first.scientific_synonyms.should be_a(Array)
      assigns[:taxon_concept].published_hierarchy_entries.first.scientific_synonyms.first.should be_a(Synonym)
    end
  end

end
