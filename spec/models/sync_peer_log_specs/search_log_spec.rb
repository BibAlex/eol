require "spec_helper"
  
describe SearchLog do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_search_log" do
    let(:user) { User.first }
    subject(:logged_search) { SearchLog.find_site_specific(100, PEER_SITE_ID)}
    
    context "when successful creation" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id, 
                                        sync_object_type_id: SyncObjectType.search_log.id,
                                        user_site_object_id: user.origin_id, sync_object_id: 100,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        parameters_values_hash = { search_term: "cat", search_type: "All",
                                   total_number_of_results: 4,
                                   ip_address_raw: "2130706433",
                                   user_agent: "user_agent",
                                   path: "http://localhost:3001/search?q=cat&search=Go" }
        create_log_action_parameters(parameters_values_hash, sync_peer_log)
        sync_peer_log.process_entry
      end
      it "creates new logged_search" do
        expect(logged_search).not_to be_nil          
      end
      it "has the correct 'search_term'" do
        expect(logged_search.search_term).to eq("cat")
      end
      it "has the correct 'search_type'" do
        expect(logged_search.search_type).to eq("All")
      end
      it "has the correct 'total_number_of_results'" do
        expect(logged_search.total_number_of_results).to eq(4)
      end
      it "has the correct 'ip_address_raw'" do
        expect(logged_search.ip_address_raw).to eq(2130706433)
      end
      it "has the correct 'user_agent'" do
        expect(logged_search.user_agent).to eq("user_agent")
      end
      it "has the correct 'user_id'" do
        expect(logged_search.user_id).to eq(user.id)
      end
      it "has the correct 'path'" do
        expect(logged_search.path).to eq("http://localhost:3001/search?q=cat&search=Go")
      end
      after(:all) do
        logged_search.destroy if logged_search
      end
    end
  end
end