require File.dirname(__FILE__) + '/../../spec_helper'

describe Admins::ContentPagesController do
  before(:all) do
    load_foundation_cache
    @admin = User.gen
    @admin.grant_admin
    @cms_user = User.gen
    @cms_user.grant_permission(:edit_cms)
    @normal_user = User.gen
  end

  before(:each) do
    session[:user_id] = nil
  end

  it 'should redirect non-logged-in users to a login page' do
    session[:user_id] = nil
    get :index
    expect(response).to redirect_to(login_url)
  end

  it 'should raise SecurityViolation for average_users' do
    session[:user_id] = @normal_user.id
    expect { get :index }.to raise_error(EOL::Exceptions::SecurityViolation)
  end

  it 'should not raise error for admins or CMS viewers' do
    session[:user_id] = @admin.id
    expect { get :index }.not_to raise_error
    session[:user_id] = @cms_user.id
    expect { get :index }.not_to raise_error
  end
  
  describe "synchronization" do
    it "should log create action" do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
      truncate_table(ActiveRecord::Base.connection, "content_pages", {})
      session[:user_id] = @admin.id
      post :create ,{"content_page"=>{"parent_content_page_id"=>"", "page_name"=>"test5", "active"=>"1"}, 
                     "translated_content_page"=>{"language_id"=>"#{Language.first.id}", 
                                                 "title"=>"test5", 
                                                 "main_content"=>"<p>hello5</p>\r\n", 
                                                 "left_content"=>"", 
                                                 "meta_keywords"=>"",
                                                 "meta_description"=>"", 
                                                 "active_translation"=>"1"}}
    #Check Syncroziation Process
      content_page = ContentPage.first
    # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "content_page"
      
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "create"
      
      # check peer logs
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == @admin.site_id
      peer_log.user_site_object_id.should == @admin.origin_id
      peer_log.sync_object_id.should == content_page.origin_id
      peer_log.sync_object_site_id.should == content_page.site_id
      
      # check log action parameters
      title_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "title")
      title_parameter[0][:value].should == "test5"
      page_name_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "page_name")
      page_name_parameter[0][:value].should == "test5"
    end
    
    it "should log delete action" do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
      truncate_table(ActiveRecord::Base.connection, "content_pages", {})
      session[:user_id] = @admin.id
      content_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"test5", "active"=>"1")
      content_page.update_column(:origin_id, content_page.id)
      content_page.update_column(:site_id, PEER_SITE_ID)                                             
      delete :destroy , {:id => content_page.id}
    
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "content_page"
      
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "delete"
      
      # check peer logs
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == @admin.site_id
      peer_log.user_site_object_id.should == @admin.origin_id
      peer_log.sync_object_id.should == content_page.origin_id
      peer_log.sync_object_site_id.should == content_page.site_id
    end
    
    it "should log move action" do
      truncate_table(ActiveRecord::Base.connection, "sync_peer_logs", {})
      truncate_table(ActiveRecord::Base.connection, "sync_log_action_parameters", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_actions", {})
      truncate_table(ActiveRecord::Base.connection, "sync_object_types", {})
      truncate_table(ActiveRecord::Base.connection, "content_pages", {})
      session[:user_id] = @admin.id
      upper_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"upper_page", "active"=>"1", "sort_order" => 1)
      upper_page.update_column(:origin_id, upper_page.id)
      upper_page.update_column(:site_id, PEER_SITE_ID)
      lower_page = ContentPage.create("parent_content_page_id"=>"", "page_name"=>"lower_page", "active"=>"1", "sort_order" => 2)
      lower_page.update_column(:origin_id, lower_page.id)
      lower_page.update_column(:site_id, PEER_SITE_ID)                                             
      post :move_down , {:id => upper_page.id}
    
      # check sync_object_type
      type = SyncObjectType.first
      type.should_not be_nil
      type.object_type.should == "content_page"
      
      # check sync_object_actions
      action = SyncObjectAction.first
      action.should_not be_nil
      action.object_action.should == "swap"
      
      # check peer logs
      SyncPeerLog.count.should == 2
      peer_log = SyncPeerLog.first
      peer_log.should_not be_nil
      peer_log.sync_object_action_id.should == action.id
      peer_log.sync_object_type_id.should == type.id
      peer_log.user_site_id .should == @admin.site_id
      peer_log.user_site_object_id.should == @admin.origin_id
      peer_log.sync_object_id.should == lower_page.origin_id
      peer_log.sync_object_site_id.should == lower_page.site_id
    end
  end
end