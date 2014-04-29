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
      session[:user_id] = @admin.id
      post :create ,{"content_page"=>{"parent_content_page_id"=>"", "page_name"=>"test5", "active"=>"1"}, 
                     "translated_content_page"=>{"language_id"=>"#{Language.first.id}", 
                                                 "title"=>"test5", 
                                                 "main_content"=>"<p>hello5</p>\r\n", 
                                                 "left_content"=>"", 
                                                 "meta_keywords"=>"",
                                                 "meta_description"=>"", 
                                                 "active_translation"=>"1"}}
                                                 

    end
  end

end
