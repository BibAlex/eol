require File.dirname(__FILE__) + '/../spec_helper'

def data_object_create_edit_variables_should_be_assigned
  assigns[:data_object].should be_a(DataObject)
  assigns[:toc_items].should_not be_nil
  assigns[:toc_items].first.should be_a(TocItem)
  assigns[:toc_items].select{|ti| ti.id == assigns[:selected_toc_item_id]}.first.should be_a(TocItem)
  assigns[:languages].first.should be_a(Language)
  assigns[:licenses].first.should be_a(License)
  assigns[:page_title].should be_a(String)
  assigns[:page_description].should be_a(String)
end

describe DataObjectsController do
  before(:all) do
    load_foundation_cache
    @taxon_concept = TaxonConcept.gen
    @user = User.gen
    @udo = @taxon_concept.add_user_submitted_text(user: @user)
  end

  # GET /pages/:taxon_id/data_objects/new
  describe 'GET new' do
    it 'should render new if logged in' do
      get :new, { :taxon_id => @taxon_concept.id } # not logged in
      response.should render_template(nil)
      expect(response).to redirect_to('/login')
      get :new, { :taxon_id => @taxon_concept.id }, { :user => @user, :user_id => @user.id }
      data_object_create_edit_variables_should_be_assigned
      assigns[:data_object].new_record?.should be_true
      response.should render_template('data_objects/new')
    end
  end

  describe 'POST create' do
    it 'should instantiate references' do
      post :create, { :taxon_id => @taxon_concept.id, :references => "Test reference.",
                      :data_object => { :toc_items => { :id => TocItem.overview.id.to_s }, :data_type_id => DataType.text.id.to_s,
                                        :object_title => "Test Article", :language_id => Language.english.id.to_s,
                                        :description => "Test text", :license_id => License.public_domain.id.to_s} },
                      { :user => @user, :user_id => @user.id }
      assigns[:references].should == "Test reference."
    end
    it 'should re-render new if model validation fails' do
      post :create, { :taxon_id => @taxon_concept.id,
                      :data_object => { :toc_items => { :id => TocItem.overview.id.to_s }, :data_type_id => DataType.text.id.to_s,
                                        :object_title => 'Blank description will fail validation',
                                        :description => '' } },
                    { :user => @user, :user_id => @user.id }
      data_object_create_edit_variables_should_be_assigned
      response.should render_template('data_objects/new')
    end
    it 'should create Link objects and prefix URLs with http://' do
      EOLWebService.should_receive('url_accepted?').with('http://eol.org').and_return(true)
      post :create, { :taxon_id => @taxon_concept.id, :commit_link => true,
                      :data_object => { :toc_items => { :id => TocItem.overview.id.to_s }, :data_type_id => DataType.text.id.to_s,
                                        :link_types => { :id => LinkType.blog.id.to_s }, :source_url => 'eol.org',
                                        :object_title => "Link to EOL", :language_id => Language.english.id.to_s,
                                        :description => "Link text" } },
                      { :user => @user, :user_id => @user.id }
      DataObject.exists?(assigns[:data_object]).should == true
      assigns[:data_object].link?.should == true
      assigns[:data_object].data_type.should == DataType.text
      assigns[:data_object].data_subtype.should == DataType.link
      assigns[:data_object].link_type.should == LinkType.blog
      assigns[:data_object].toc_items.should == [ TocItem.overview ]
      assigns[:data_object].source_url.should == "http://eol.org"  # even though it was submitted as eol.org
    end
    it 'fails validation on invalid link URLs' do
      EOLWebService.should_receive('url_accepted?').at_least(3).times.with('http://').and_return(false)
      post :create, { :taxon_id => @taxon_concept.id, :commit_link => true,
                      :data_object => { :toc_items => { :id => TocItem.overview.id.to_s }, :data_type_id => DataType.text.id.to_s,
                                        :link_types => { :id => LinkType.blog.id.to_s }, :source_url => 'http://',
                                        :object_title => "Link to EOL", :language_id => Language.english.id.to_s,
                                        :description => "Link text" } },
                      { :user => @user, :user_id => @user.id }
      expect(assigns[:data_object]).to have(1).error_on(:source_url)
      expect(assigns[:data_object].errors_on(:source_url)).to include(I18n.t(:url_not_accessible))
    end
  end

  describe 'GET edit' do
    it 'should not allow access to user who do not own the users data object' do
      another_user = User.gen()
      get :edit, { :id => @udo.id }, { :user => another_user, :user_id => another_user.id }
      flash[:error].should == I18n.t('exceptions.security_violations.default')
    end
    it 'should only render edit users data object of data type text and owned by current user' do
      get :edit, { :id => @udo.id }, { :user => @user, :user_id => @user.id }
      data_object_create_edit_variables_should_be_assigned
      response.should render_template('data_objects/edit')
    end
  end

  describe 'PUT update' do
    it 'should re-render edit if validation fails' do
      put :update, { :id => @udo.id,
                     :data_object => { :rights_holder => @user.full_name, :source_url => "", :rights_statement => "",
                                       :toc_items => { :id => @udo.toc_items.first.id.to_s }, :bibliographic_citation => "",
                                       :data_type_id => DataType.text.id.to_s, :object_title =>"test_master",
                                       :description => "", :license_id => License.public_domain.id.to_s },
                                       :language_id => Language.english.id.to_s },
                   { :user => @user, :user_id => @user.id }
      data_object_create_edit_variables_should_be_assigned
      response.should render_template('data_objects/edit')
    end
    it 'should create a new data object revision'
  end

  describe 'GET crop' do
    before(:each) do
      @image = DataObject.gen(:data_type_id => DataType.image.id, :object_cache_url => FactoryGirl.generate(:image))
    end

    it 'should not allow access to non-curators' do
      get :crop, { :id => @image.id }
      response.should redirect_to(login_url)

      expect { get :crop, { :id => @image.id }, { :user => @user, :user_id => @user.id } }.
        to raise_error(EOL::Exceptions::SecurityViolation) {|e| e.flash_error_key.should == :min_assistant_curators_only}
    end

    it 'should allow access to curators' do
      curator = build_curator(TaxonConcept.gen, :level => :assistant)
      original_object_cache_url = @image.object_cache_url
      new_object_cache_url = FactoryGirl.generate(:image)
      new_object_cache_url.should_not == original_object_cache_url
      @image.object_cache_url.should == original_object_cache_url
      ContentServer.should_receive(:update_data_object_crop).and_return(new_object_cache_url)
      get :crop, { :id => @image.id, :x => 0, :y => 0, :w => 1 }, { :user => curator, :user_id => curator.id }
      @image.reload
      @image.object_cache_url.should == new_object_cache_url
      response.should redirect_to(data_object_path(@image))
      flash[:notice].should == "Image was cropped successfully."
    end
  end
  
  describe "Synchronization" do
    describe "association Synchronization" do
      let(:data_object) {DataObject.first} 
      let(:he) {HierarchyEntry.first} 
      before(:all) do
        truncate_all_tables
        load_foundation_cache
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
        data_object.update_attributes(origin_id: data_object.id, site_id: PEER_SITE_ID)
        he.update_attributes(origin_id: he.id, site_id: PEER_SITE_ID)
      end
      
      describe "PUT #save_association" do
        let(:type) {SyncObjectType.data_object}
        let(:action) {SyncObjectAction.save_association}
        let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
        let(:current_user) {User.gen}
        
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users_data_objects","users"])
          current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID)
          UsersDataObject.create(user_id: current_user.id, data_object_id: data_object.id,
                               taxon_concept_id: TaxonConcept.first.id)
          session[:user_id] = current_user.id
          put :save_association, {id: data_object.id, hierarchy_entry_id: he.id}
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
          expect(peer_log.sync_object_id).to eq(data_object.origin_id)
        end
        it "creates sync peer log with correct sync_object_site_id" do
          expect(peer_log.sync_object_site_id).to eq(data_object.site_id)
        end
        it "creates sync log action parameter for hierarchy_entry_origin_id" do
          hierarchy_entry_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "hierarchy_entry_origin_id")
          expect(hierarchy_entry_origin_id_parameter[0][:value]).to eq("#{he.origin_id}")
        end
        it "creates sync log action parameter for hierarchy_entry_site_id" do
          hierarchy_entry_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "hierarchy_entry_site_id")
          expect(hierarchy_entry_site_id_parameter[0][:value]).to eq("#{he.site_id}")
        end
      end
      
      describe "GET #remove_association" do
        let(:type) {SyncObjectType.data_object}
        let(:action) {SyncObjectAction.remove_association}
        let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
        let(:curator) {User.gen(curator_level: CuratorLevel.full_curator, credentials: 'Blah', curator_scope: 'More blah')}
        
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users_data_objects","users",
                           "curated_data_objects_hierarchy_entries"])
          curator.update_attributes(origin_id: curator.id, site_id: PEER_SITE_ID)
          session[:user_id] = curator.id
          cdoh = CuratedDataObjectsHierarchyEntry.create(vetted_id: Vetted.first.id,
                 visibility_id: Visibility.visible.id, user_id: curator.id, 
                 data_object_guid: data_object.guid, hierarchy_entry_id: HierarchyEntry.first.id,
                 data_object_id: data_object.id)
          get :remove_association, {id: data_object.id, hierarchy_entry_id: he.id}
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
          expect(peer_log.user_site_id).to eq(curator.site_id)
        end
        it "creates sync peer log with correct user_site_object_id" do
          expect(peer_log.user_site_object_id).to eq(curator.origin_id)
        end
        it "creates sync peer log with correct sync_object_id" do
          expect(peer_log.sync_object_id).to eq(data_object.origin_id)
        end
        it "creates sync peer log with correct sync_object_site_id" do
          expect(peer_log.sync_object_site_id).to eq(data_object.site_id)
        end
      end
      
      describe "PUT #curate_associations" do
        let(:curator) {User.gen(curator_level: CuratorLevel.full_curator, credentials: 'Blah', curator_scope: 'More blah')}
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","users_data_objects","users",
                           "curated_data_objects_hierarchy_entries","comments"])
          curator.update_attributes(origin_id: curator.id, site_id: PEER_SITE_ID)
          session[:user_id] = curator.id
          cdoh = CuratedDataObjectsHierarchyEntry.create(vetted_id: Vetted.first.id,
                          visibility_id: Visibility.visible.id, user_id: curator.id, 
                          data_object_guid: data_object.guid, hierarchy_entry_id: HierarchyEntry.first.id,
                          hierarchy_entry: HierarchyEntry.first, data_object_id: data_object.id)
        end
        context "curation without erros" do
          before do
            put :curate_associations, {id: data_object.id,
                                       return_to: "http://localhost:#{PEER_SITE_ID}/data_objects/#{data_object.id}",
                                       vetted_id_1: Vetted.first.id, 
                                       curation_comment_1: "comment1",
                                       untrust_reasons_1: ["3"],
                                       hide_reasons_1: ["3"],
                                       vetted_id_1: "1"}
          end
          describe "create comment for association" do
            let(:type) {SyncObjectType.comment}
            let(:action) {SyncObjectAction.create}
            let(:comment) {Comment.first}
            let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
            
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
              expect(peer_log.user_site_id).to eq(curator.site_id)
            end
            it "creates sync peer log with correct user_site_object_id" do
              expect(peer_log.user_site_object_id).to eq(curator.origin_id)
            end
            it "creates sync peer log with correct sync_object_id" do
              expect(peer_log.sync_object_id).to eq(comment.origin_id)
            end
            it "creates sync peer log with correct sync_object_site_id" do
              expect(peer_log.sync_object_site_id).to eq(comment.site_id)
            end
            it "creates sync log action parameter for first_comment_body" do
              first_comment_body_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "body")
              expect(first_comment_body_parameter[0][:value]).to eq("comment1") 
            end
            it "creates sync peer log with correct first_comment_parent_type" do
              first_comment_parent_type_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "parent_type")
              expect(first_comment_parent_type_parameter[0][:value]).to eq("DataObject")
            end
            it "creates sync peer log with correct first_comment_parent_site_id" do
              first_comment_parent_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "comment_parent_site_id")
              expect(first_comment_parent_site_id_parameter[0][:value]).to eq("#{data_object.site_id}")  
            end
            it "creates sync peer log with correct first_comment_parent_origin_id" do
              first_comment_parent_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "comment_parent_origin_id")
              expect(first_comment_parent_origin_id_parameter[0][:value]).to eq("#{data_object.origin_id}") 
            end
          end
          
          describe "review association" do
            let(:type) {SyncObjectType.data_object}
            let(:action) {SyncObjectAction.curate_associations}
            let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
            
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
              expect(peer_log.user_site_id).to eq(curator.site_id)
            end
            it "creates sync peer log with correct user_site_object_id" do
              expect(peer_log.user_site_object_id).to eq(curator.origin_id)
            end
            it "creates sync peer log with correct sync_object_id" do
              expect(peer_log.sync_object_id).to eq(data_object.origin_id)
            end
            it "creates sync peer log with correct sync_object_site_id" do
              expect(peer_log.sync_object_site_id).to eq(data_object.site_id)
            end
            it "creates sync log action parameter for untrust_reasons" do
              untrust_reasons_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "untrust_reasons")
              expect(untrust_reasons_parameter[0][:value]).to eq("#{UntrustReason.find_by_id(3).class_name},") 
            end
            it "creates sync log action parameter for hide_reasons" do
              hide_reasons_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "hide_reasons")
              expect(hide_reasons_parameter[0][:value]).to eq("#{UntrustReason.find_by_id(3).class_name},") 
            end
            it "creates sync log action parameter for hierarchy_entry_origin_id" do
              hierarchy_entry_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "hierarchy_entry_origin_id")
              expect(hierarchy_entry_origin_id_parameter[0][:value]).to eq("#{he.origin_id}") 
            end
            it "creates sync log action parameter for hierarchy_entry_site_id" do
              hierarchy_entry_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "hierarchy_entry_site_id")
              expect(hierarchy_entry_site_id_parameter[0][:value]).to eq("#{he.site_id}") 
            end
          end
        end
        context "curation with erros" do
          before do
            put :curate_associations, {id: data_object.id,
                                       return_to: "http://localhost:#{PEER_SITE_ID}/data_objects/#{data_object.id}",
                                       vetted_id_1: "1", 
                                       curation_comment_1: "",
                                       visibility_id_1: "1"}
          end
          it "does nothing" do
            flash[:error].should =~ /Please choose a reason/i
          end
          it "should not create peer log" do
            expect(SyncPeerLog.count).to eq(0)
          end
        end
      end
    end
    
    describe "data_object management sychronization" do
      before(:all) do
        truncate_all_tables
        load_foundation_cache
        Activity.create_enumerated
        Visibility.create_enumerated
        SyncObjectType.create_enumerated
        SyncObjectAction.create_enumerated
        TocItem.gen_if_not_exists(label: 'overview')
        taxon_concept.update_attributes(origin_id: taxon_concept.id, site_id: PEER_SITE_ID)
      end
      let(:current_user) {User.first}
      let(:taxon_concept) {TaxonConcept.first}
      before do
        current_user.update_attributes(origin_id: current_user.id, site_id: PEER_SITE_ID)
        session[:user_id] = current_user.id
      end
      describe "create new data object synchonization" do
        let(:data_object) {DataObject.last}
        let(:ref) {Ref.last}
        let(:data_obj_taxon_concept) {DataObjectsTaxonConcept.first }
        let(:col_item) {CollectionItem.first}
        
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters","data_objects"])
          toc_item = TocItem.overview
          toc_item.update_attributes(origin_id: toc_item.id, site_id: PEER_SITE_ID)
          post :create, { taxon_id: taxon_concept.id, references: "Test reference.",
                          data_object: { toc_items: { id: toc_item.id.to_s }, data_type_id: DataType.text.id.to_s,
                                         object_title: "Test Article", language_id: Language.english.id.to_s,
                                         description: "Test text", license_id: License.public_domain.id.to_s} },
                          { user: current_user, user_id: current_user.id }
        end
        
        describe "creating reference synchronization" do
          let(:type) {SyncObjectType.ref}
          let(:action) {SyncObjectAction.create}
          let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
          
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
          it "creates sync log action parameter for full_reference" do
            full_reference_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "reference")
            expect(full_reference_parameter[0][:value]).to eq("Test reference.") 
          end
        end
        
        describe "creating data_object synchronization" do
          let(:type) {SyncObjectType.data_object}
          let(:action) {SyncObjectAction.create}
          let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
          let(:toc) {TocItem.find(TocItem.overview.id)}
          
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
            expect(peer_log.sync_object_id).to eq(data_object.origin_id)
          end
          it "creates sync peer log with correct sync_object_site_id" do
            expect(peer_log.sync_object_site_id).to eq(data_object.site_id)
          end
          it "creates sync log action parameter for taxon_concept_origin_id" do
            taxon_concept_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_origin_id")
            expect(taxon_concept_origin_id_parameter[0][:value]).to eq("#{taxon_concept.origin_id}") 
          end
          it "creates sync log action parameter for taxon_concept_site_id" do
            taxon_concept_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "taxon_concept_site_id")
            expect(taxon_concept_site_id_parameter[0][:value]).to eq("#{taxon_concept.site_id}") 
          end
          it "creates sync log action parameter for toc_id" do
            toc_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "toc_id")
            expect(toc_id_parameter[0][:value]).to eq("#{toc.origin_id}") 
          end
          it "creates sync log action parameter for toc_site_id" do
            toc_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "toc_site_id")
            expect(toc_site_id_parameter[0][:value]).to eq("#{toc.site_id}") 
          end
          it "creates sync log action parameter for object_title" do
            object_title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "object_title")
            expect(object_title_parameter[0][:value]).to eq("Test Article") 
          end
          it "creates sync log action parameter for description" do
            description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
            expect(description_parameter[0][:value]).to eq("Test text") 
          end
          it "creates sync log action parameter for data_type_id" do
            data_type_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "data_type_id")
            expect(data_type_id_parameter[0][:value]).to eq(DataType.text.id.to_s) 
          end
          it "creates sync log action parameter for language_id" do
            language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
            expect(language_id_parameter[0][:value]).to eq(Language.english.id.to_s) 
          end
          it "creates sync log action parameter for license_id" do
            license_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "license_id")
            expect(license_id_parameter[0][:value]).to eq(License.public_domain.id.to_s) 
          end
        end
        
        describe "creating collection item synchronization" do
          let(:type) {SyncObjectType.collection_item}
          let(:action) {SyncObjectAction.add}
          let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
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
            expect(peer_log.sync_object_id).to eq(current_user.watch_collection.origin_id)
          end
          it "creates sync peer log with correct sync_object_site_id" do
            expect(peer_log.sync_object_site_id).to eq(current_user.watch_collection.site_id)
          end
          it "creates sync log action parameter for item_id" do
            collection_origin_ids_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "item_id")
            expect(collection_origin_ids_parameter[0][:value]).to eq("#{data_object.origin_id}") 
          end
          it "creates sync log action parameter for item_site_id" do
            collection_site_ids_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "item_site_id")
            expect(collection_site_ids_parameter[0][:value]).to eq("#{data_object.site_id}") 
          end  
          it "creates sync log action parameter for collected_item_type" do
            collected_item_type_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collected_item_type")
            expect(collected_item_type_parameter[0][:value]).to eq("DataObject") 
          end   
          it "creates sync log action parameter for collected_item_name" do
            collected_item_name_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "collected_item_name")
            expect(collected_item_name_parameter[0][:value]).to eq("#{data_object.object_title}") 
          end  
        end
      end
      
      describe "update data object synchronization" do
        let(:data_object) {taxon_concept.add_user_submitted_text(user: current_user)}
        let(:new_data_object) {DataObject.last}
        let(:ref) {Ref.last}
        
        before(:all) do
          data_object.update_attributes(origin_id: data_object.id, site_id: PEER_SITE_ID)
          data_object.refs << Ref.new(full_reference: "Test reference", user_submitted: true, published: 1,
                                      visibility: Visibility.visible)
        end
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = current_user.id
          put :update, { id: data_object.id,
                         data_object: { source_url: "", rights_statement: "",
                                        toc_items: { id: data_object.toc_items.first.id.to_s }, bibliographic_citation: "",
                                        data_type_id: DataType.text.id.to_s, object_title: "test_master",
                                        description: "desc", license_id: License.public_domain.id.to_s,
                                        language_id: Language.english.id.to_s }, 
                                        references: "Test reference"},
                       { user: current_user, user_id: current_user.id }
        end
        
        describe "creating reference synchronization" do
          let(:type) {SyncObjectType.ref}
          let(:action) {SyncObjectAction.create}
          let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
         
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
          it "creates sync log action parameter for full_reference" do
            full_reference_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "reference")
            expect(full_reference_parameter[0][:value]).to eq("Test reference") 
          end
        end
        
        describe "update data object" do
          let(:type) {SyncObjectType.data_object}
          let(:action) {SyncObjectAction.update}
          let(:peer_log) {SyncPeerLog.find_by_sync_object_type_id(type.id)}
          let(:toc) {TocItem.find(TocItem.overview.id)}
          before(:all) do
            toc.update_attributes(origin_id: toc.id, site_id: PEER_SITE_ID)
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
            expect(peer_log.sync_object_id).to eq(data_object.origin_id)
          end
          it "creates sync peer log with correct sync_object_site_id" do
            expect(peer_log.sync_object_site_id).to eq(data_object.site_id)
          end
          it "creates sync log action parameter for new_revision_origin_id" do
            new_data_object_origin_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "new_revision_origin_id")
            expect(new_data_object_origin_id_parameter[0][:value]).to eq("#{new_data_object.origin_id}") 
          end
          it "creates sync log action parameter for new_revision_site_id" do
            new_data_object_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "new_revision_site_id")
            expect(new_data_object_site_id_parameter[0][:value]).to eq("#{new_data_object.site_id}") 
          end
          it "creates sync log action parameter for references" do
            toc_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "toc_id")
            expect(toc_id_parameter[0][:value]).to eq("#{toc.origin_id}") 
          end
          it "creates sync log action parameter for toc_site_id" do
            toc_site_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "toc_site_id")
            expect(toc_site_id_parameter[0][:value]).to eq("#{toc.site_id}") 
          end
          it "creates sync log action parameter for object_title" do
            object_title_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "object_title")
            expect(object_title_parameter[0][:value]).to eq("test_master") 
          end
          it "creates sync log action parameter for description" do
            description_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "description")
            expect(description_parameter[0][:value]).to eq("desc") 
          end
          it "creates sync log action parameter for data_type_id" do
            data_type_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "data_type_id")
            expect(data_type_id_parameter[0][:value]).to eq(DataType.text.id.to_s) 
          end
          it "creates sync log action parameter for language_id" do
            language_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "language_id")
            expect(language_id_parameter[0][:value]).to eq(Language.english.id.to_s) 
          end
          it "creates sync log action parameter for license_id" do
            license_id_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "license_id")
            expect(license_id_parameter[0][:value]).to eq(License.public_domain.id.to_s) 
          end
        end
      end
      
      describe "rate data object synchronization" do
        let(:type) {SyncObjectType.data_object}
        let(:action) {SyncObjectAction.rate}
        let(:peer_log) {SyncPeerLog.find_by_sync_object_action_id(action.id)}
        let(:data_obj) {taxon_concept.add_user_submitted_text(user: current_user)}
        before do
          truncate_tables(["sync_peer_logs","sync_log_action_parameters"])
          session[:user_id] = current_user.id
          taxon_concept = TaxonConcept.gen
          data_obj.update_attributes(origin_id: data_obj.id, site_id: PEER_SITE_ID)
          data_obj.refs << Ref.new(full_reference: "Test reference", user_submitted: true, published: 1,
                                                   visibility: Visibility.visible)
          get :rate,  { id: data_obj.id, 
                        minimal: false, return_to: "http://localhost:3001/data_objects/#{data_obj.id}", 
                        stars: 2}
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
            expect(peer_log.sync_object_id).to eq(data_obj.origin_id)
          end
          it "creates sync peer log with correct sync_object_site_id" do
            expect(peer_log.sync_object_site_id).to eq(data_obj.site_id)
          end
          it "creates sync log action parameter for stars" do
            stars_parameter = SyncLogActionParameter.where(peer_log_id: peer_log.id, parameter: "stars")
            expect(stars_parameter[0][:value]).to eq("2") 
          end
          after(:each) do
            TaxonConcept.last.destroy
          end
      end
    end
  end
end
