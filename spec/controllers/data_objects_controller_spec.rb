require "spec_helper"

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
    @udo = @taxon_concept.add_user_submitted_text(:user => @user)
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
      TocItem.gen_if_not_exists(:label => 'overview')
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
      TocItem.gen_if_not_exists(:label => 'overview')
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
      TocItem.gen_if_not_exists(:label => 'overview')
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
  
  
  
    # add items to collections synchronization
  describe "mange data objects synchronization" do
    
    describe "add association" do
      before(:each) do
        truncate_all_tables
        load_foundation_cache
        
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
      end
      
      it "should add association" do
        data_object = DataObject.gen
        data_object.update_column(:origin_id, data_object.id)
        data_object.update_column(:site_id, 1)
        
        he = HierarchyEntry.first
        he.update_column(:origin_id, he.id)
        he.update_column(:site_id, 1)
        
        put :save_association, {:id => data_object.id, :hierarchy_entry_id => he.id}
        cdoh = CuratedDataObjectsHierarchyEntry.find_by_hierarchy_entry_id_and_data_object_id(HierarchyEntry.first.id, data_object.id)
        cdoh.should_not be_nil
        
        # check sync_object_type
        type = SyncObjectType.first
        type.should_not be_nil
        type.object_type.should == "data_object"
  
        # check sync_object_actions
        action = SyncObjectAction.first
        action.should_not be_nil
        action.object_action.should == "save_association"
  
        # check peer log for creating new collection
        peer_log = SyncPeerLog.first
        peer_log.should_not be_nil
        peer_log.sync_object_action_id.should == action.id
        peer_log.sync_object_type_id.should == type.id
        peer_log.user_site_id.should == @current_user.site_id
        peer_log.user_site_object_id.should == @current_user.origin_id
        peer_log.sync_object_id.should == data_object.origin_id
        peer_log.sync_object_site_id.should == data_object.site_id
        
        # check log action parameters
        hierarchy_entry_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "hierarchy_entry_origin_id")
        hierarchy_entry_origin_id_parameter[0][:value].should == "#{he.origin_id}"
        hierarchy_entry_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => peer_log.id, :parameter => "hierarchy_entry_site_id")
        hierarchy_entry_site_id_parameter[0][:value].should == "#{he.site_id}"
      end
    end
    
    describe "remove association" do
      before(:each) do
        truncate_all_tables
        load_foundation_cache
        
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
      end
      
      it "should add association" do
        data_object = DataObject.gen
        cdoh = CuratedDataObjectsHierarchyEntry.create(:vetted_id => Vetted.first.id,
        :visibility_id => Visibility.visible.id, :user_id => @current_user.id, 
        :data_object_guid => data_object.guid, :hierarchy_entry_id => HierarchyEntry.first.id,
        :data_object_id => data_object.id)
        get "/data_objects/#{data_object.id}/remove_association/#{HierarchyEntry.first.id}"
#        get :remove_association, {:id =>, :hierarchy_entry_id => }
          
        CuratedDataObjectsHierarchyEntry.find_by_data_object_guid_and_data_object_id(data_object.guid,
                                         data_object.id).should be_nil
      end
    end
    
    describe "create new data object" do
      before(:each) do
        truncate_all_tables
        load_foundation_cache
        Activity.create_enumerated
        Visibility.create_enumerated
        TocItem.gen_if_not_exists(:label => 'overview')
        
        @current_user = User.gen
        session[:user_id] = @current_user.id
        @current_user[:origin_id] = @current_user.id
        @current_user[:site_id] = PEER_SITE_ID
        @current_user.save
        @taxon_concept = TaxonConcept.gen
       
      end
      
      it 'should save creating data object paramters in synchronization tables' do
        post :create, { :taxon_id => @taxon_concept.id, :references => "Test reference.",
                      :data_object => { :toc_items => { :id => TocItem.overview.id.to_s }, :data_type_id => DataType.text.id.to_s,
                                        :object_title => "Test Article", :language_id => Language.english.id.to_s,
                                        :description => "Test text", :license_id => License.public_domain.id.to_s} },
                      { :user => @current_user, :user_id => @current_user.id }
         
          
        # created data object
        data_obj = DataObject.find(2)
        data_obj.object_title.should == "Test Article"
        data_obj.description.should == "Test text"
        data_obj.license_id.should == License.public_domain.id
        user_data_obj = UsersDataObject.first
        user_data_obj.user_id.should == @current_user.id
        data_obj.toc_items[0].id.should == TocItem.overview.id
        # check created references
        ref = Ref.first
        ref.full_reference.should == "Test reference."
        ref.user_submitted.should == true
        ref.visibility_id.should == Visibility.visible.id
        ref.published.should == 1         
        data_obj_ref = data_obj.refs[0]
        data_obj_ref.id.should == ref.id  
        
        # check created record for data object taxon concept
        data_obj_taxon_concept = DataObjectsTaxonConcept.first 
        data_obj_taxon_concept.taxon_concept_id.should == @taxon_concept.id
        data_obj_taxon_concept.data_object_id.should == data_obj.id
        
        col_item = CollectionItem.first        
        col_item.collected_item_type.should == "DataObject"
        col_item.collected_item_id.should == data_obj.id
        col_item.collection_id.should == @current_user.watch_collection.id        
        
        # check sync_object_type
        ref_type = SyncObjectType.first
        ref_type.should_not be_nil
        ref_type.object_type.should == "Ref"
        
        data_object_type = SyncObjectType.find(2)
        data_object_type.should_not be_nil
        data_object_type.object_type.should == "data_object"
        
        collection_type = SyncObjectType.find(3)
        collection_type.should_not be_nil
        collection_type.object_type.should == "Collection"

        # check sync_object_actions
        create_action = SyncObjectAction.first
        create_action.should_not be_nil
        create_action.object_action.should == "create"
        
        add_item_action = SyncObjectAction.find(2)
        add_item_action.should_not be_nil
        add_item_action.object_action.should == "add_item"
         
        # check peer logs
        create_ref_peer_log = SyncPeerLog.first
        create_ref_peer_log.should_not be_nil
        create_ref_peer_log.sync_object_action_id.should == create_action.id
        create_ref_peer_log.sync_object_type_id.should == ref_type.id
        create_ref_peer_log.user_site_id .should == PEER_SITE_ID
        create_ref_peer_log.user_site_object_id.should == @current_user.id

         # check log action parameters
        full_reference_parameter = SyncLogActionParameter.where(:peer_log_id => create_ref_peer_log.id, :parameter => "reference")
        full_reference_parameter[0][:value].should == "Test reference."
        
        create_data_object_peer_log = SyncPeerLog.find(2)
        create_data_object_peer_log.should_not be_nil
        create_data_object_peer_log.sync_object_action_id.should == create_action.id
        create_data_object_peer_log.sync_object_type_id.should == data_object_type.id
        create_data_object_peer_log.user_site_id .should == PEER_SITE_ID
        create_data_object_peer_log.user_site_object_id.should == @current_user.id
        create_data_object_peer_log.sync_object_id.should == data_obj.origin_id
        create_data_object_peer_log.sync_object_site_id.should == data_obj.site_id

         # check log action parameters
        toc = TocItem.find(TocItem.overview.id)
        
        taxon_concept_origin_id_parameter = SyncLogActionParameter.where(:peer_log_id => create_data_object_peer_log.id, :parameter => "taxon_concept_origin_id")
        taxon_concept_origin_id_parameter[0][:value].should == @taxon_concept.origin_id
        
        taxon_concept_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => create_data_object_peer_log.id, :parameter => "taxon_concept_site_id")
        taxon_concept_site_id_parameter[0][:value].should == "#{@taxon_concept.site_id}"
        
        references_parameter = SyncLogActionParameter.where(:peer_log_id => create_data_object_peer_log.id, :parameter => "references")
        references_parameter[0][:value].should == "Test reference."
        
        toc_id_parameter = SyncLogActionParameter.where(:peer_log_id => create_data_object_peer_log.id, :parameter => "toc_id")
        toc_id_parameter[0][:value].should == toc.origin_id
        
        toc_site_id_parameter = SyncLogActionParameter.where(:peer_log_id => create_data_object_peer_log.id, :parameter => "toc_site_id")
        toc_site_id_parameter[0][:value].should == toc.site_id
        
        # check peer logs
        create_collection_item_peer_log = SyncPeerLog.find(3)
        create_collection_item_peer_log.should_not be_nil
        create_collection_item_peer_log.sync_object_action_id.should == add_item_action.id
        create_collection_item_peer_log.sync_object_type_id.should == collection_type.id
        create_collection_item_peer_log.user_site_id .should == PEER_SITE_ID
        create_collection_item_peer_log.user_site_object_id.should == @current_user.id
        create_collection_item_peer_log.sync_object_id.should == @current_user.watch_collection.id
        create_collection_item_peer_log.sync_object_site_id.should == @current_user.watch_collection.site_id

        # check log action parameters
        collection_origin_ids_parameter = SyncLogActionParameter.where(:peer_log_id => create_collection_item_peer_log.id, :parameter => "item_id")
        collection_origin_ids_parameter[0][:value].should == "#{data_obj.origin_id}"
        collection_site_ids_parameter = SyncLogActionParameter.where(:peer_log_id => create_collection_item_peer_log.id, :parameter => "item_site_id")
        collection_site_ids_parameter[0][:value].should == "#{data_obj.site_id}"
    
    
        collected_item_type_parameter = SyncLogActionParameter.where(:peer_log_id => create_collection_item_peer_log.id, :parameter => "collected_item_type")
        collected_item_type_parameter[0][:value].should == "DataObject"
        collected_item_name_parameter = SyncLogActionParameter.where(:peer_log_id => create_collection_item_peer_log.id, :parameter => "collected_item_name")
        collected_item_name_parameter[0][:value].should == "#{data_obj.object_title}"
      end
    end
  end
  
  
end
