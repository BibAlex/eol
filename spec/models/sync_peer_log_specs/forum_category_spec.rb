require "spec_helper"
  
describe ForumCategory do
  before(:all) do
    truncate_all_tables
    load_foundation_cache
    SyncObjectType.create_enumerated
    SyncObjectAction.create_enumerated
  end
  
  describe ".create_category" do
    before do
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.create.id,
                                      sync_object_type_id: SyncObjectType.category.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: 80, #create a new one with this origin_id 
                                      sync_object_site_id: PEER_SITE_ID)
      parameters_values_hash = { title: "cat_title", description: "cat_description"}
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "creates new category" do
      category = ForumCategory.find_by_title_and_description("cat_title", "cat_description")
      expect(category).not_to be_nil
    end
    after do
      if ForumCategory.find_by_title_and_description("cat_title", "cat_description")
        ForumCategory.find_by_title_and_description("cat_title", "cat_description").destroy
      end
    end
  end
  
  describe ".update_category" do
    let(:category) {ForumCategory.gen}
    before do
      category.update_attributes(origin_id: category.id, site_id: PEER_SITE_ID)
      user = User.first
      user.update_attributes(active: true, origin_id: user.id, site_id: PEER_SITE_ID, admin: 1)
      sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.update.id,
                                      sync_object_type_id: SyncObjectType.category.id,
                                      user_site_object_id: user.origin_id,
                                      user_site_id: user.site_id, 
                                      sync_object_id: category.origin_id, 
                                      sync_object_site_id: category.site_id)
      parameters_values_hash = { title: "new_cat_title", description: "new_cat_description"}
      create_log_action_parameters(parameters_values_hash, sync_peer_log)
      sync_peer_log.process_entry
    end
    it "updates category" do
      category = ForumCategory.find_by_title_and_description("new_cat_title", "new_cat_description")
      expect(category).not_to be_nil
    end
    after do
      if ForumCategory.find_by_title_and_description("new_cat_title", "new_cat_description")
        ForumCategory.find_by_title_and_description("new_cat_title", "new_cat_description").destroy
      end
    end
  end
  
  describe ".delete_category" do
    let(:forum_category) { ForumCategory.gen(user_id: user.id) }
    let(:user) { User.first }
    
    context "when successful deletion" do
      before(:all) do
        truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
        user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
        forum_category.update_attributes(origin_id: forum_category.id, site_id: PEER_SITE_ID)
        @forum_category_id = forum_category.id
        sync_peer_log = SyncPeerLog.gen(sync_object_action_id: SyncObjectAction.delete.id, 
                                        sync_object_type_id: SyncObjectType.category.id,
                                        user_site_object_id: user.origin_id, sync_object_id: forum_category.origin_id,
                                        user_site_id: user.site_id,
                                        sync_object_site_id: PEER_SITE_ID)
        sync_peer_log.process_entry
      end
      it "deletes forum category" do
        expect(ForumCategory.find_site_specific(@forum_category_id, PEER_SITE_ID)).to be_nil
      end
      after(:all) do
        forum_category.destroy if forum_category
      end
    end
  end
end