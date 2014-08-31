require "spec_helper"
  
describe NewsItem do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_news_item" do
    before do
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.news_item.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, #create a new one with this origin_id 
                                      sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = { page_name: "create_news" ,
                                 "display_date(3i)" => 5,
                                 "display_date(2i)" => 8,
                                 "display_date(1i)" => 2014,
                                 "display_date(4i)" => 12,
                                 "display_date(5i)" => 42,
                                 "activated_on(3i)" => 5,
                                 "activated_on(2i)" => 8,
                                 "activated_on(1i)" => 2014,
                                 "activated_on(4i)" => 12,
                                 "activated_on(5i)" => 42,
                                 "active" => 1,
                                 title: "create_title",
                                 body: "create_body", 
                                 language_id: 1,
                                 active_translation: 1 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new news item" do
      news = NewsItem.find_by_origin_id(80)
      expect(news).not_to be_nil 
    end
    after do
      NewsItem.find_by_origin_id(80).destroy if NewsItem.find_by_origin_id(80)
    end
  end
  describe ".update_news_item" do
    let(:news_item) { NewsItem.gen(page_name: "old_name") }
    before do
      news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.news_item.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: news_item.origin_id, 
                                      sync_object_site_id: news_item.site_id)
      parameters_values_hash = { page_name: "new_name" ,
                                 "display_date(3i)" => 5,
                                 "display_date(2i)" => 8,
                                 "display_date(1i)" => 2014,
                                 "display_date(4i)" => 12,
                                 "display_date(5i)" => 42,
                                 "activated_on(3i)" => 5,
                                 "activated_on(2i)" => 8,
                                 "activated_on(1i)" => 2014,
                                 "activated_on(4i)" => 12,
                                 "activated_on(5i)" => 42,
                                 "active" => 1 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "updates news item" do
      news = NewsItem.find_by_origin_id(news_item.origin_id)
      expect(news.page_name).to eq("new_name") 
    end
    after do
      NewsItem.find(news_item.id).destroy if NewsItem.find(news_item.id)
    end
  end
  
  describe ".delete_news_item" do
    let(:news_item) { NewsItem.gen(page_name: "old_name") }
    before do
      news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.news_item.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: news_item.origin_id,
                                      sync_object_site_id: news_item.site_id)
      parameters_values_hash = {}
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "deletes news item" do
      expect(NewsItem.find_by_origin_id(news_item.origin_id)).to be_nil
    end
  end
end