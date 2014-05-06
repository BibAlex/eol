require "spec_helper"

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
    session[:user_id] = @admin.id
    post :create
    expect(response).to redirect_to(login_url)
  end
end