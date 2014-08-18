require "spec_helper"

describe SearchController do
  describe 'index' do
    before(:all) do
      truncate_all_tables
      Language.create_english
    end
  end

  it "should find no results on an empty search" do
    Language.create_english
    get :index, :q => ''
    assigns[:all_results].should == []
  end
  
  describe "Synchronization" do
    before(:all) do
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
    end
      
    describe "POST #create" do
      let(:peer_log) { SyncPeerLog.where("sync_object_action_id = ? and sync_object_type_id =? 
                                          and sync_object_id = ? and sync_object_site_id = ?", 
                                          SyncObjectAction.create.id, SyncObjectType.search_log.id,
                                          logged_search.origin_id, PEER_SITE_ID).first }
      let(:user) { User.gen }
      subject(:logged_search) { SearchLog.last }
      
      context "when successful creation" do
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
          session[:user_id] = user.id
          get :index, :q => 'cat'
        end
        it "creates sync peer log" do
          expect(peer_log).not_to be_nil
        end
        it "has correct action" do
          expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
        end
        it "has correct type" do
          expect(peer_log.sync_object_type_id).to eq(SyncObjectType.search_log.id)
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
          expect(peer_log.sync_object_id).to eq(logged_search.origin_id)
        end
        it "creates sync log action parameter for 'search_term'" do
          search_term_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "search_term")
          expect(search_term_parameter[0][:value]).to eq("cat")
        end
        it "creates sync log action parameter for 'search_type'" do
          search_type_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "search_type")
          expect(search_type_parameter[0][:value]).to eq("All")
        end
        it "creates sync log action parameter for 'total_number_of_results'" do
          total_number_of_results_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "total_number_of_results")
          expect(total_number_of_results_parameter[0][:value].to_i).to eq(logged_search.total_number_of_results)
        end
        it "creates sync log action parameter for 'ip_address_raw'" do
          ip_address_raw_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "ip_address_raw")
          expect(ip_address_raw_parameter[0][:value].to_i).to eq(logged_search.ip_address_raw)
        end
        it "creates sync log action parameter for 'user_agent'" do
          user_agent_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "user_agent")
          expect(user_agent_parameter[0][:value]).to eq(logged_search.user_agent)
        end
        it "creates sync log action parameter for 'path'" do
          path_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "path")
          expect(path_parameter[0][:value]).to eq(logged_search.path)
        end
        after do
          logged_search.destroy if logged_search
          user.destroy if user
        end
      end
    end
  end
end
