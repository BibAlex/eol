require File.dirname(__FILE__) + '/../../spec_helper'

describe Taxa::NamesController do

  before(:each) do
    truncate_all_tables
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
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

  describe "Synchronization" do
    describe "GET #delete" do
      let(:type) {SyncObjectType.common_name}
      let(:action) {SyncObjectAction.delete}
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
      let(:current_user) {@testy[:curator]}
      before do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        session[:user_id] = current_user.id
        get :delete, :taxon_id => @testy[:taxon_concept].id.to_i, :synonym_id => @testy[:synonym]["synonym"].id
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
        expect(peer_log.sync_object_id).to eq(@testy[:synonym]["synonym"].origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(@testy[:synonym]["synonym"].site_id)
      end
      it "creates sync log action parameter for taxon_concept_origin_id" do
        taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
        expect(taxon_concept_origin_id_parameter[0][:value]).to eq(@testy[:taxon_concept].origin_id)
      end
      it "creates sync log action parameter for taxon_concept_site_id" do
        taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
        expect(taxon_concept_site_id_parameter[0][:value]).to eq("#{@testy[:taxon_concept].site_id}")
      end
    end
    
    describe 'POST #create' do
      let(:type) {SyncObjectType.common_name}
      let(:action) {SyncObjectAction.create}
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
      let(:current_user) {@testy[:curator]}
      let(:approved_languages) {Language.approved_languages.collect{|l| l.id}}
        
      before :each do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        session[:user_id] = @testy[:curator].id
        approved_language_id = approved_languages.first
        post :create, :name => { :synonym => { :language_id => approved_language_id }, :string => "snake" }, 
                      :commit_add_common_name => "Add name", :taxon_id => @testy[:taxon_concept].id.to_i
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
        expect(peer_log.sync_object_id).to eq(Synonym.last.origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(Synonym.last.site_id)
      end
      it "creates sync log action parameter for taxon_concept_origin_id" do
        taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
        expect(taxon_concept_origin_id_parameter[0][:value]).to eq(@testy[:taxon_concept].origin_id)
      end
      it "creates sync log action parameter for taxon_concept_site_id" do
        taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
        expect(taxon_concept_site_id_parameter[0][:value]).to eq(@testy[:taxon_concept].site_id.to_s)
      end
      it "creates sync log action parameter for string" do
        string_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "string")
        expect(string_parameter[0][:value]).to eq('snake')
      end
      it "creates sync log action parameter for name_origin_id" do
        name_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "name_origin_id")
        expect(name_origin_id_parameter[0][:value]).to eq(Name.last.origin_id.to_s)
      end
      it "creates sync log action parameter for name_site_id" do
        name_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "name_site_id")
        expect(name_site_id_parameter[0][:value]).to eq(Name.last.site_id.to_s)
      end
      after(:all) do
        Name.last.destroy
        Synonym.last.destroy
        TaxonConceptName.last.destroy
      end
    end

    describe 'POST #update' do
      let(:type) {SyncObjectType.common_name}
      let(:action) {SyncObjectAction.update}
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
      let(:current_user) {@testy[:curator]}
      let(:approved_languages) {Language.approved_languages.collect{|l| l.id}}
        
      before do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        session[:user_id] = current_user.id
        approved_language_id = approved_languages.first
        post :update, :preferred_name_id => @testy[:name].id, :language_id => approved_language_id, :taxon_id => @testy[:taxon_concept].id.to_i
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
        expect(peer_log.sync_object_id).to eq(@testy[:synonym]["synonym"].origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(@testy[:synonym]["synonym"].site_id)
      end
      it "creates sync log action parameter for taxon_concept_origin_id" do
        taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
        expect(taxon_concept_origin_id_parameter[0][:value]).to eq(@testy[:taxon_concept].origin_id)
      end
      it "creates sync log action parameter for taxon_concept_site_id" do
        taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
        expect(taxon_concept_site_id_parameter[0][:value]).to eq(@testy[:taxon_concept].site_id.to_s)
      end
      it "creates sync log action parameter for language" do
        language_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language")
        expect(language_parameter[0][:value]).to eq(approved_languages.first.to_s)
      end
      it "creates sync log action parameter for string" do
        string_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "string")
        expect(string_parameter[0][:value]).to eq(@testy[:name].string)
      end
    end
    
    describe "GET #vet_common_name" do
      let(:type) {SyncObjectType.common_name}
      let(:action) {SyncObjectAction.vet}
      let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
      let(:current_user) {@testy[:curator]}
      let(:approved_languages) {Language.approved_languages.collect{|l| l.id}}
      before do
        truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
        truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
        session[:user_id] = current_user.id
        approved_language_id = approved_languages.first
        get :vet_common_name, :id => @testy[:name].id, :language_id => approved_language_id, :vetted_id => Vetted.first.id, :taxon_id => @testy[:taxon_concept].id.to_i
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
        expect(peer_log.sync_object_id).to eq(@testy[:synonym]["synonym"].origin_id)
      end
      it "creates sync peer log with correct sync_object_site_id" do
        expect(peer_log.sync_object_site_id).to eq(@testy[:synonym]["synonym"].site_id)
      end
      it "creates sync log action parameter for taxon_concept_origin_id" do
        taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
        expect(taxon_concept_origin_id_parameter[0][:value]).to eq(@testy[:taxon_concept].origin_id)
      end
      it "creates sync log action parameter for taxon_concept_site_id" do
        taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
        expect(taxon_concept_site_id_parameter[0][:value]).to eq(@testy[:taxon_concept].site_id.to_s)
      end
      it "creates sync log action parameter for taxon_concept_site_id" do
        language_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language")
        expect(language_parameter[0][:value]).to eq(approved_languages.first.to_s)
      end
      it "creates sync log action parameter for vetted_view_order" do
        vetted_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "vetted_view_order")
        expect(vetted_parameter[0][:value]).to eq(Vetted.first.view_order.to_s)
      end
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
