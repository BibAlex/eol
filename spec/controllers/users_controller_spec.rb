require "spec_helper"

describe UsersController do

  before(:all) do
    unless @user = User.find_by_username('users_controller_spec')
      truncate_all_tables
      Language.create_english
      SpecialCollection.gen(name: 'Watch')
      CuratorLevel.create_enumerated
      UserIdentity.create_enumerated
      Activity.create_enumerated
      @user = User.gen(username: 'users_controller_spec')
      cot = ChangeableObjectType.gen(ch_object_type: 'synonym')
    end
  end

  describe 'GET new' do
    it 'should render new unless logged in' do
      get :new
      response.should render_template('users/new')
      response.status.should == 200
      assigns[:user].open_authentications.should be_blank
      get :new, nil, { user: @user, user_id: @user.id }
      response.should_not render_template('users/new')
      expect(response).to redirect_to(@user)
    end

    context 'extended for open authentication' do
      it 'should redirect to authorize uri when log in is with Facebook' do
        get :new, { oauth_provider: 'facebook' }
        response.header['Location'].should =~ /^https:\/\/graph.facebook.com\/oauth\/authorize/
      end
      it 'should redirect to authorize uri when log in is with Google' do
        get :new, { oauth_provider: 'google' }
        response.header['Location'].should =~ /^https:\/\/accounts.google.com\/o\/oauth2\/auth/
      end
      it 'should redirect to authorize uri when log in is with Twitter' do
        stub_oauth_requests
        get :new, { oauth_provider: 'twitter' }
        response.header['Location'].should =~ /https:\/\/api.twitter.com\/oauth\/authenticate/
      end
      it 'should redirect to authorize uri when log in is with Yahoo' do
        stub_oauth_requests
        get :new, { oauth_provider: 'yahoo' }
        response.header['Location'].should =~ /https:\/\/api.login.yahoo.com\/oauth\/v2\/request_auth/
      end
      it 'should clear session data when user cancels sign up at confirmation page' do
        get :new, nil, {:oauth_token_yahoo_1234 => 'atoken', :oauth_secret_yahoo_1234 => 'asecret'}
        session[:oauth_token_yahoo_1234].should be_nil
        session[:oauth_secret_yahoo_1234].should be_nil
      end
      it 'should render confirmation page when user signs up with Facebook' do
        stub_oauth_requests
        params_data, session_data = oauth_request_data(:facebook, 2)
        get :new, params_data, session_data
        assigns[:open_auth].should be_a(EOL::OpenAuth::Facebook)
        assigns[:user].new_record?.should be_true
        assigns[:user].open_authentications.first.provider.should == 'facebook'
        assigns[:user].open_authentications.first.guid.should == 'facebookuserguid'
        assigns[:user].open_authentications.length.should == 1
        assigns[:user].given_name.should == 'FacebookGiven'
        assigns[:user].family_name.should == 'FacebookFamily'
      end
      it 'should redirect to new user URL and flash error if user denies access during Twitter sign up' do
        oauth1_consumer = OAuth::Consumer.new("key", "secret", {
          :site => "http://fake.oauth1.provider",
          :request_token_path => "/example/request_token",
          :access_token_path => "/example/access_token_denied",
          :authorize_path => "/example/authorize" })
        OAuth::Consumer.should_receive(:new).and_return(oauth1_consumer)
        get :new, { :denied => "key",
                    :oauth_provider => 'twitter'},
                  { "twitter_request_token_token" => 'key',
                    "twitter_request_token_secret" => 'secret' }
        assigns[:open_auth].should be_a(EOL::OpenAuth::Twitter)
        expect(response).to redirect_to(new_user_url)
        flash[:error].should match /Sorry, we are not authorized.+?Twitter/
      end
      it 'should redirect to new user URL and flash error if user denies access during Facebook sign up' do
        get :new, {:error => "access_denied", :oauth_provider => "facebook"}
        assigns[:open_auth].should be_a(EOL::OpenAuth::Facebook)
        expect(response).to redirect_to(new_user_url)
        flash[:error].should match /Sorry, we are not authorized.+?Facebook/
      end
      it 'should redirect to new user URL and flash error if user denies access during Google sign up' do
        get :new, {:error => "access_denied", :oauth_provider => "google"}
        assigns[:open_auth].should be_a(EOL::OpenAuth::Google)
        expect(response).to redirect_to(new_user_url)
        flash[:error].should match /Sorry, we are not authorized.+?Google/
      end
    end
  end

  describe 'POST create' do
    context 'extended for open authentication' do
      it 'should create a new EOL account connected to a Facebook account, send welcome email and log in user'
      it 'should create a new EOL account connected to a Google account, send welcome email and log in user'
      it 'should create a new EOL account connected to a Twitter account, send welcome email and log in user'
      it 'should create a new EOL account connected to a Yahoo! account, send welcome email and log in user'
      it 'should not create an EOL account is third-party account is already connected to an EOL user'
    end
    it 'should create a new EOL user and send verification email if registration is valid'
    it 'should not create a new user if registration is invalid'
    
    describe 'create user synchronization' do
      before(:all) do
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
        SpecialCollection.create_enumerated
      end
      
      describe "POST #create" do
        let(:peer_log) { SyncPeerLog.first }
        subject(:user) { User.first }
        
        context "when successful creation" do
          before do
            truncate_tables(["sync_peer_logs","sync_log_action_parameters", "users"])
            post :create, { user: { username: 'user_1', given_name: 'user', 
                            email: "user1@yahoo.com",  email_confirmation: "user1@yahoo.com", 
                            entered_password: "HELLO", entered_password_confirmation: "HELLO", 
                            agreed_with_terms: 1 } }
          end
          it "creates sync peer log" do
            expect(peer_log).not_to be_nil
          end
          it "has correct action" do
            expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.create.id)
          end
          it "has correct type" do
            expect(peer_log.sync_object_type_id).to eq(SyncObjectType.user.id)
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
            expect(peer_log.sync_object_id).to eq(user.id)
          end
          it "creates sync log action parameter for 'user_name'" do
            username_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "username")
            expect(username_parameter[0][:value]).to eq("user_1")
          end
          it "creates sync log action parameter for 'language'" do
            language_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language")
            lang = Language.find_by_source_form("English")
            expect(language_parameter[0][:value]).to eq("#{lang.id}")
          end
          it "creates sync log action parameter for 'validation_code'" do
            validation_code_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "validation_code")
            expect(validation_code_parameter[0][:value]).to eq("#{user.validation_code}")
          end
          it "creates sync log action parameter for 'collection_origin_id'" do
            collection_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collection_origin_id")
            expect(collection_origin_id_parameter[0][:value]).to eq("#{user.watch_collection.id}")
          end
          it "creates sync log action parameter for 'agreed_with_terms'" do
            agreed_with_terms_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "agreed_with_terms")
            expect(!(agreed_with_terms_parameter[0][:value].to_i.zero?)).to eq(user.agreed_with_terms)
          end
        end
        
        context "when creation fails because 'username' should not be empty" do
          before do
            truncate_tables(["sync_peer_logs","sync_log_action_parameters","users"])
            post :create, { user: { given_name: 'user', 
                            email: "user1@yahoo.com",  email_confirmation: "user1@yahoo.com", 
                            entered_password: "HELLO", entered_password_confirmation: "HELLO", 
                            agreed_with_terms: 1 } }
          end
          it "doesn't create sync peer log" do
            expect(peer_log).to be_nil
          end
          it "doesn't create sync log action parameters" do
            expect(SyncLogActionParameter.all).to be_blank
          end
        end
        
        context "when creation fails because 'email' should not be empty" do
          before do
            truncate_tables(["sync_peer_logs","sync_log_action_parameters","users"])
            post :create, { user: { username: 'user_1', given_name: 'user', 
                            entered_password: "HELLO", entered_password_confirmation: "HELLO", 
                            agreed_with_terms: 1 } }
          end
          it "doesn't create sync peer log" do
            expect(peer_log).to be_nil
          end
          it "doesn't create sync log action parameters" do
            expect(SyncLogActionParameter.all).to be_blank
          end
        end
        
        context "when creation fails because 'password' should not be empty" do
          before do
            truncate_tables(["sync_peer_logs","sync_log_action_parameters","users"])
            post :create, { user: { username: 'user_1', given_name: 'user', 
                           email: "user1@yahoo.com",  email_confirmation: "user1@yahoo.com", 
                           agreed_with_terms: 1 } }
          end
          it "doesn't create sync peer log" do
            expect(peer_log).to be_nil
          end
          it "doesn't create sync log action parameters" do
            expect(SyncLogActionParameter.all).to be_blank
          end
        end
        
      end
    end
  end

  describe 'GET show' do
    it 'should render show' do
      get :show, { :id => @user.id }
      assigns[:user].should == @user
      response.should render_template('users/show')
    end
  end

  describe 'GET edit' do
    it 'should raise error if edit before log in' do
      expect { get :edit, { :id => @user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should raise security violation if edit wrong user' do
      user = User.gen
      session[:user_id] = @user.id
      expect { get :edit, { :id => user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should render edit properly if editing self' do
      get :edit, { :id => @user.id }, { :user => @user, :user_id => @user.id }
      assigns[:user].should == @user
      response.should render_template('users/edit')
      response.status.should == 200
    end
  end

  describe 'PUT update' do
    it 'should raise error if not logged in' do
      hashed_password = User.find(@user).hashed_password
      expect{ put :update, { :id => @user.id, :user => { :id => @user.id, :entered_password => 'newpassword', 
        :entered_password_confirmation => 'newpassword' } } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should update and render show if updating self' do
      hashed_password = User.find(@user).hashed_password
      session[:user_id] = @user.id
      User.find(@user).hashed_password.should == hashed_password
      put :update, { :id => @user.id, :user => { :id => @user.id, :entered_password => 'newpassword',
                                                 :entered_password_confirmation => 'newpassword' } }
      user = User.find(@user)
      user.hashed_password.should_not == hashed_password
      user.hashed_password.should == User.hash_password('newpassword')
      expect(response).to redirect_to(@user)
    end
    it 'should render edit on validation errors' do
      hashed_password = User.find(@user).hashed_password
      session[:user_id] = @user.id
      put :update, { :id => @user.id, :user => { :id => @user.id, :entered_password => 'abc',
                                                 :entered_password_confirmation => 'abc' } }
      User.find(@user).hashed_password.should == hashed_password
      response.should render_template('users/edit')
    end
    it 'should ignore entered passwords when password confirmation is blank and entered password is same as existing password' do # i.e. passwords auto filled by browser
      user = User.gen(:password => 'secret')
      hashed_password = user.hashed_password
      username = user.username
      bio = user.bio
      put :update, { :id => user.id, :user => { :id => user.id, :entered_password => 'secret',
                                                :entered_password_confirmation => '',
                                                :username => 'myusername', :bio => 'My bio' } },
                   { :user => user, :user_id => user.id }
      user = User.find(user)
      user.hashed_password.should == hashed_password
      user.username.should_not == username
      user.username.should == 'myusername'
      user.bio.should_not == bio
      user.bio.should == 'My bio'
    end
    it 'should render curation privileges on validation errors for curator application' do
      user = User.gen
      put :update, { :id => user.id, :commit_curation_privileges_put => 'Curation application',
                     :user => { :id => user.id, :username => user.username, :credentials => '',
                                :requested_curator_level_id => CuratorLevel.master_curator.id } },
                   { :user => user, :user_id => user.id }
      response.should render_template('users/curation_privileges')
      assigns[:user].errors.any?.should be_true
    end
    it 'should allow instant approval for assistant curators without requirements' do
      user = User.gen
      # create curator community if it doesn't exist
      Community.find_or_create_by_description_and_name($CURATOR_COMMUNITY_DESC, $CURATOR_COMMUNITY_NAME)
      put :update, { :id => user.id, :commit_curation_privileges_put => 'Curation application',
                     :user => { :id => user.id, :username => user.username, :credentials => '',
                                :requested_curator_level_id => CuratorLevel.assistant_curator.id } },
                   { :user => user, :user_id => user.id }
      assigns[:user].errors.any?.should be_false
      assigns[:user].curator_level_id.should == CuratorLevel.assistant_curator.id
    end
    
    describe 'update user synchronization' do
      before(:all) do
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
        SpecialCollection.create_enumerated
      end
      
      describe "PUT #update" do
        let(:peer_log) { SyncPeerLog.first }
        subject(:user) { User.gen }
        
        context "when successful update" do
          before do
            truncate_tables(["sync_peer_logs","sync_log_action_parameters","users"])
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            session[:user_id] = user.id
            put :update, { id: user.id, user: {id: user.id, username: 'newusername', 
                          bio: 'My bio' } }
          end
          it "creates sync peer log" do
            expect(peer_log).not_to be_nil
          end
          it "has correct action" do
            expect(peer_log.sync_object_action_id).to eq(SyncObjectAction.update.id)
          end
          it "has correct type" do
            expect(peer_log.sync_object_type_id).to eq(SyncObjectType.user.id)
          end
          it "has correct 'user_site_id'" do
            expect(peer_log.user_site_id).to eq(PEER_SITE_ID)
          end
          it "has correct 'user_id'" do
            expect(peer_log.user_site_object_id).to eq(user.id)
          end
          it "has correct 'object_site_id'" do
            expect(peer_log.sync_object_site_id).to eq(PEER_SITE_ID)
          end
          it "has correct 'object_id'" do
            expect(peer_log.sync_object_id).to eq(user.id)
          end
          it "creates sync log action parameter for 'user_name'" do
            username_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "username")
            expect(username_parameter[0][:value]).to eq("newusername")
          end
          it "creates sync log action parameter for 'bio'" do
            bio_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "bio")
            expect(bio_parameter[0][:value]).to eq("My bio")
          end
        end
        
        context "when update fails because the user isn't logged in" do
          before do
            truncate_tables(["sync_peer_logs","sync_log_action_parameters","users"])
            user.update_attributes(origin_id: user.id, site_id: PEER_SITE_ID)
            hashed_password = User.find(user).hashed_password
            expect{ put :update, { id: user.id, user: { id: user.id, entered_password: 'newpassword', 
                                              entered_password_confirmation: 'newpassword' } } }.to raise_error(EOL::Exceptions::SecurityViolation)
          end
          it "doesn't create sync peer log" do
             expect(peer_log).to be_nil
          end
          it "doesn't create sync log action parameters" do
            expect(SyncLogActionParameter.all).to be_blank
          end
        end
      end
    end
  end

  describe 'GET curation_privileges' do
    it 'should raise error when not logged in' do
      expect{ get :curation_privileges, { :id => @user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should render curation privileges only if applying for self' do
      user = User.gen
      session[:user_id] = @user.id
      expect { get :curation_privileges, { :id => user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
    it 'should render curation privileges properly' do
      user = User.gen
      session[:user_id] = @user.id
      get :curation_privileges, { :id => @user.id }
      assigns[:user].should == @user
      response.should render_template('users/curation_privileges')
      response.status.should == 200
    end
  end

  describe 'GET verify' do
    it 'should not activate already active user' do
      active_user = User.gen(:active => true, :validation_code => User.generate_key)
      Notifier.should_not_receive(:user_activated)
      Notifier.should_not_receive(:user_verification)
      get :verify, { :user_id => active_user.id, :validation_code => active_user.validation_code }
      expect(response).to redirect_to(login_path)
    end
    it 'should activate inactive user with valid verification code' do
      user = User.gen(:active => false, :validation_code => User.generate_key)
      mailer = double
      mailer.should_receive(:deliver)
      Notifier.should_receive(:user_activated).once.with(user).and_return(mailer)
      get :verify, { :user_id => user.id, :validation_code => user.validation_code }
      user.reload
      user.active.should be_true
      session[:conversion_code].should =~ /^[0-9a-f]{40}$/
      expect(response).to redirect_to(activated_user_path(user, :success => session[:conversion_code]))
    end
    it 'should not activate user with invalid verification code' do
      inactive_user = User.gen(:active => false, :validation_code => User.generate_key)
      Notifier.should_not_receive(:user_activated)
      mailer = double
      mailer.should_receive(:deliver)
      Notifier.should_receive(:user_verification).once.with(inactive_user, verify_user_url(inactive_user.id, inactive_user.validation_code)).
        and_return(mailer)
      get :verify, { :user_id => inactive_user.id, :validation_code => 'invalidverificationcode123' }
      expect(response).to redirect_to(pending_user_path(inactive_user))
    end
    it 'should ignore validation errors on user model' do
      user = User.gen(:active => false, :validation_code => User.generate_key)
      user.update_attributes(:agreed_with_terms => false)
      user.errors[:agreed_with_terms].should == ['must be accepted']
      user.active?.should be_false
      get :verify, { :user_id => user.id, :validation_code => user.validation_code }
      user.reload
      user.active.should be_true
      expect(response).to redirect_to(activated_user_path(user, :success => session[:conversion_code]))
    end
  end

  describe 'GET pending' do
    it 'should render pending' do
      get :pending, { :id => @user.id }
      assigns[:user].should == @user
      response.should render_template('users/pending')
    end
  end

  describe 'GET activated' do
    it 'should render activated' do
      get :activated, { :id => @user.id }
      assigns[:user].should == @user
      response.should render_template('users/activated')
    end
    it 'should know whether its a valid conversion for tracking' do
      get :activated, { :id => @user.id }
      assigns[:conversion].should be_nil
      conversion_code = User.generate_key
      get :activated, { :id => @user.id, :success => conversion_code }
      assigns[:conversion].should be_nil
      get :activated, { :id => @user.id }, { :success => conversion_code }
      assigns[:conversion].should be_nil
      get :activated, { :id => @user.id, :success => conversion_code },
                      { :conversion_code => conversion_code }
      assigns[:conversion].should be_a(EOL::GoogleAdWords::Conversion)
    end
  end

  describe 'GET terms_agreement' do
    before(:each) do
      @disagreeable_user = User.gen
      @disagreeable_user.update_column(:agreed_with_terms, 0)
    end
    it 'should render terms agreement' do
      User.find(@disagreeable_user).agreed_with_terms.should be_false
      TranslatedContentPage.gen(:content_page => ContentPage.gen(:page_name => 'terms_of_use'),
                                :active_translation => 1,
                                :language => Language.english)
      get :terms_agreement, { :id => @disagreeable_user.id }, 
                            { :user => @disagreeable_user, :user_id => @disagreeable_user.id }
      assigns[:user].should == @disagreeable_user
      assigns[:terms].should be_a(TranslatedContentPage)
      response.should render_template('users/terms_agreement')
    end
    it 'should force users to agree to terms before viewing other pages' do
      User.find(@disagreeable_user).agreed_with_terms.should be_false
      get :show, { :id => @disagreeable_user.id }, 
                 { :user => @disagreeable_user, :user_id => @disagreeable_user.id }
      expect(response).to redirect_to(terms_agreement_user_path(@disagreeable_user))
      get :edit, { :id => @disagreeable_user.id },
                 { :user => @disagreeable_user, :user_id => @disagreeable_user.id }
      expect(response).to redirect_to(terms_agreement_user_path(@disagreeable_user))
    end
    it 'should not allow users to render terms for another user' do
      User.find(@disagreeable_user).agreed_with_terms.should be_false
      expect{ get :terms_agreement, { :id => @disagreeable_user.id } }.
        to raise_error(EOL::Exceptions::SecurityViolation) # anonymous user trying to access user terms
      expect{ get :terms_agreement, { :id => @disagreeable_user.id },
              { :user => @user, :user_id => @user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
    end
  end

  describe 'POST terms_agreement' do
    before(:each) do
      @disagreeable_user = User.gen
      @disagreeable_user.update_column(:agreed_with_terms, 0)
    end
    it 'should allow the current user to agree to terms' do
      User.find(@disagreeable_user).agreed_with_terms.should be_false
      post :terms_agreement, { :id => @disagreeable_user.id, :commit_agreed => 'I Agree' }, { :user => @disagreeable_user, :user_id => @disagreeable_user.id }
      User.find(@disagreeable_user).agreed_with_terms.should be_true
      expect(response).to redirect_to(user_url(@disagreeable_user))
    end
    it 'should not allow users to agree to terms for another user' do
      User.find(@disagreeable_user).agreed_with_terms.should be_false
      expect{ post :terms_agreement, { :id => @disagreeable_user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
      User.find(@disagreeable_user).agreed_with_terms.should be_false
      expect{ post :terms_agreement, { :id => @disagreeable_user.id }, { :user => @user, :user_id => @user.id } }.to raise_error(EOL::Exceptions::SecurityViolation)
      User.find(@disagreeable_user).agreed_with_terms.should be_false
    end
  end

  describe 'GET recover account' do
    it 'should render recover account unless logged in' do
      get :recover_account
      response.should render_template('users/recover_account')
      response.status.should == 200
      get :recover_account, nil, { :user => @user, :user_id => @user.id }
      response.should_not render_template('users/recover_account')
      expect(response).to redirect_to(@user)
    end
  end

  describe 'POST recover account' do
    before :all do
      unless @recover_user = User.find_by_username('recover_account_spec')
        @recover_user = User.gen(:username => 'recover_account_spec', :email => 'unique@address.com')
      end
    end
    it "should find user by email or flash error if it can't find user by email" do
      post :recover_account, { :user => { :email => '' } }
      flash[:error].should_not be_blank
      assigns[:users].should be_blank
      response.should render_template('users/recover_account')
      response.status.should == 200
      post :recover_account, { :user => { :email => 'userdoesnotexist' } }
      assigns[:users].should be_blank
      response.should render_template('users/recover_account')
      flash[:error].should_not be_blank
      response.status.should == 200
    end
    it 'should raise exception if user is hidden' do
      @recover_user.update_attributes(:hidden => true)
      @recover_user.hidden.should be_true
      expect{ post :recover_account, :user => { :email => @recover_user.email } }.
        to raise_error(EOL::Exceptions::SecurityViolation)
      @recover_user.update_attributes(:hidden => false)
    end
    it 'should give user a new recover account token and send recover account email' do
      mailer = double
      mailer.should_receive(:deliver)
      Notifier.should_receive(:user_recover_account).
        with(@recover_user, /users\/#{@recover_user.id}\/temporary_login\/[a-f0-9]{40}$/i).
        and_return(mailer)
      post :recover_account, :user => { :email => @recover_user.email }
      @recover_user.reload
      @recover_user.recover_account_token.should =~ /^[0-9a-f]{40}$/i
      expect(response).to redirect_to(login_path)
      flash[:notice].should =~ /further instructions/i
    end
    it 'should render choose account first if multiple accounts found' do
      shared_email_address = 'fake@email.com'
      user1 = User.gen(:email => shared_email_address)
      user2 = User.gen(:email => shared_email_address)
      user3 = User.gen(:email => shared_email_address)
      post :recover_account, :user => {:email => shared_email_address}
      assigns[:users].size.should == 3
      assigns[:users].all?{|u| u.recover_account_token.blank? }.should be_true
      response.should render_template('users/recover_account_choose_account')
      mailer = double
      mailer.should_receive(:deliver)
      Notifier.should_receive(:user_recover_account).
        with(user1, /users\/#{user1.id}\/temporary_login\/[a-f0-9]{40}$/).
        and_return(mailer)
      post :recover_account, { :commit_choose_account => 'Send email',
                               :user => { :email => shared_email_address, :id => user1.id } }
      user1.reload
      user1.recover_account_token.should =~ /^[0-9a-f]{40}$/
      expect(response).to redirect_to(login_path)
      flash[:notice].should =~ /further instructions/i
    end
    it 'should ignore validation errors on user model' do
      @recover_user.update_attributes(:agreed_with_terms => false)
      @recover_user.errors[:agreed_with_terms].should == ['must be accepted']
      mailer = double
      mailer.should_receive(:deliver)
      Notifier.should_receive(:user_recover_account).
        with(@recover_user, /users\/#{@recover_user.id}\/temporary_login\/[a-f0-9]{40}$/i).
        and_return(mailer)
      post :recover_account, :user => { :email => @recover_user.email }
      @recover_user.reload
      @recover_user.recover_account_token.should =~ /^[0-9a-f]{40}$/i
      expect(response).to redirect_to(login_path)
      flash[:notice].should =~ /further instructions/i
      @recover_user.update_attributes(:agreed_with_terms => true)
    end
  end

  describe 'GET temporary_login' do
    it 'should log in users with valid token' do
      user = User.gen(:recover_account_token => User.generate_key,
                      :recover_account_token_expires_at => 24.hours.from_now)
      get :temporary_login, :user_id => user.id, :recover_account_token => user.recover_account_token
      expect(response).to redirect_to(edit_user_path(user))
      user.reload
      user.recover_account_token.should be_nil
      user.recover_account_token_expires_at.should be_nil
      session[:user_id].should == user.id
    end
    it 'should not log in users with invalid token' do
      user = User.gen(:recover_account_token => User.generate_key,
                      :recover_account_token_expires_at => 24.hours.from_now)
      get :temporary_login, :user_id => user.id, :recover_account_token => 'invalidtoken'
      session[:user_id].should_not == user.id
      expect(response).to redirect_to(recover_account_users_path)
    end
    it 'should not log in users with expired token' do
      user = User.gen(:recover_account_token => User.generate_key,
                      :recover_account_token_expires_at => 24.hours.ago)
      get :temporary_login, :user_id => user.id, :recover_account_token => user.recover_account_token
      session[:user_id].should_not == user.id
      expect(response).to redirect_to(recover_account_users_path)
    end
    it 'should not log in hidden users' do
       user = User.gen(:recover_account_token => User.generate_key,
                       :recover_account_token_expires_at => 24.hours.from_now,
                       :hidden => true)
      expect { get :temporary_login, :user_id => user.id, :recover_account_token => user.recover_account_token}.to raise_error(EOL::Exceptions::SecurityViolation)
    end
  end

  describe 'GET verify_open_authentication' do
    it 'should redirect to new open authentication if user is logged' do
      expect { get :verify_open_authentication }.to raise_error(EOL::Exceptions::SecurityViolation)
      params_to_redirect = { :some_param => 'some param' }
      get :verify_open_authentication, params_to_redirect, {:user_id => 1}
      expect(response).to redirect_to(new_user_open_authentication_url(params_to_redirect.merge({:user_id => 1})))
    end
  end
  
  describe 'GET unsubscribe_notifications' do
    before(:each) do
      @user1 = User.gen(:email => 'test1@example.com', :disable_email_notifications => false)
      @user2 = User.gen(:email => 'test1@example.com', :disable_email_notifications => false)
      @user3 = User.gen(:email => 'test1@example.com', :disable_email_notifications => false)
      @user4 = User.gen(:email => 'test2@example.com', :disable_email_notifications => false)
      @user_already_gone = User.gen(:email => 'test3@example.com', :disable_email_notifications => true)
    end
    it 'should allow users to unsubscribe to notifications' do
      get :unsubscribe_notifications, :user_id => @user1.id, :key => @user1.unsubscribe_key
      @user1.reload; @user2.reload; @user3.reload; @user4.reload
      @user1.disable_email_notifications.should be_true
      @user2.disable_email_notifications.should be_true
      @user3.disable_email_notifications.should be_true
      @user4.disable_email_notifications.should be_false
    end
    it 'should show users they are already unsubscribed to notifications if they are already unsubscribed' do
      get :unsubscribe_notifications, :user_id => @user_already_gone.id, :key => @user_already_gone.unsubscribe_key
      flash[:notice].should == I18n.t(:already_unsubscribed, :scope => [:users, :unsubscribe_notifications])
    end
    it 'should show access_denied if the key provided while unsubscribing to notifications is not valid' do
      get :unsubscribe_notifications, :user_id => @user1.id, :key => "thisisafakekeytounsubscribe"
      flash[:error].should == I18n.t('exceptions.security_violations.default')
    end
  end
  
  describe 'GET unsubscribe_notifications' do
    before(:all) do
      @user1 = User.gen(:email => 'test1@example.com', :disable_email_notifications => false)
      @user2 = User.gen(:email => 'test1@example.com', :disable_email_notifications => false)
      @user3 = User.gen(:email => 'test1@example.com', :disable_email_notifications => false)
      @user4 = User.gen(:email => 'test2@example.com', :disable_email_notifications => false)
      @user_already_gone = User.gen(:email => 'test3@example.com', :disable_email_notifications => true)
    end
    it 'should allow users to unsubscribe to notifications' do
      get :unsubscribe_notifications, :user_id => @user1.id, :key => @user1.unsubscribe_key
      @user1.reload; @user2.reload; @user3.reload; @user4.reload
      @user1.disable_email_notifications.should be_true
      @user2.disable_email_notifications.should be_true
      @user3.disable_email_notifications.should be_true
      @user4.disable_email_notifications.should be_false
    end
    it 'should show users they are already unsubscribed to notifications if they are already unsubscribed' do
      get :unsubscribe_notifications, :user_id => @user_already_gone.id, :key => @user_already_gone.unsubscribe_key
      flash[:notice].should == I18n.t(:already_unsubscribed, :scope => [:users, :unsubscribe_notifications])
    end
    it 'should show access_denied if the key provided while unsubscribing to notifications is not valid' do
      get :unsubscribe_notifications, :user_id => @user1.id, :key => "thisisafakekeytounsubscribe"
      flash[:error].should == I18n.t('exceptions.security_violations.default')
    end
  end
end