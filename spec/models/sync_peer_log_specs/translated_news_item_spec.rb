require "spec_helper"
  
describe TranslatedNewsItem do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_translated_news_item" do
    let(:news_item) { NewsItem.gen(page_name: "name") }
    before do
      news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.translated_news_item.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: news_item.origin_id,
                                      sync_object_site_id: news_item.site_id)
      parameters_values_hash = { title: "create_title",
                                 body: "create_body", 
                                 language_id: 1,
                                 active_translation: 1 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new news item" do
      translated_news = TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id)
      expect(translated_news).not_to be_nil 
    end
    after do
      if TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id)
        TranslatedNewsItem.find_by_language_id_and_news_item_id(1, news_item.id).destroy
      end
    end
  end
  
  describe ".update_translated_news_item" do
    let(:news_item) { NewsItem.gen(page_name: "name") }
    before do
      translated_news_item = TranslatedNewsItem.create(title: "french", 
              body: "french", language_id: 2, news_item_id: news_item.id)
      news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.translated_news_item.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: news_item.origin_id, 
                                      sync_object_site_id: news_item.site_id)
      parameters_values_hash = { title: "updated_title",
                                 body: "updated_body", 
                                 language_id: 2,
                                 active_translation: 1 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "updates translated news item" do
      updated_translated_news = TranslatedNewsItem.find_by_language_id_and_news_item_id(
        2, news_item.id)
      expect(updated_translated_news.title).to eq("updated_title") 
      expect(updated_translated_news.body).to eq("updated_body") 
    end
    after do
      NewsItem.find_by_page_name("name").destroy
      if TranslatedNewsItem.find_by_language_id_and_news_item_id(2, news_item.id)
        TranslatedNewsItem.find_by_language_id_and_news_item_id(2, news_item.id).destroy
      end
    end
  end
  
  describe ".delete_translated_news_item" do
    let(:news_item) { NewsItem.gen(page_name: "name") }
    before do
      translated_news_item = TranslatedNewsItem.create(title: "french", 
        body: "french", language_id: 2, news_item_id: news_item.id)
      news_item.update_attributes(origin_id: news_item.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id,
                                      sync_object_type_id: SyncObjectType.translated_news_item.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: news_item.origin_id,
                                      sync_object_site_id: news_item.site_id)
      parameters_values_hash = { language_id: 2 }
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "deletes new news item" do
      expect(TranslatedNewsItem.find_by_language_id_and_news_item_id(2,news_item.id)).to be_nil
    end
  end
end