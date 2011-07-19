require File.dirname(__FILE__) + '/../spec_helper'

def it_should_collect_item(collectable_item_path, collectable_item)
  visit collectable_item_path
  click_button 'Add to my collection'
  if current_url.match /#{login_url}/
    page.fill_in 'user_username', :with => @anon_user.username
    page.fill_in 'user_password', :with => 'password'
    click_button 'Login Now »'
    current_url.should match /#{collectable_item_path}/
    body.should include('added to collection')
    @anon_user.watch_collection.items.map {|li| li.object }.include?(collectable_item).should be_true
    visit logout_url
  else
    current_url.should match /#{collectable_item_path}/
    body.should include('added to collection')
    @user.watch_collection.items.map {|li| li.object }.include?(collectable_item).should be_true
  end
end

describe "Collections and collecting:" do

  before(:all) do
    # so this part of the before :all runs only once
    unless User.find_by_username('collections_scenario')
      truncate_all_tables
      load_scenario_with_caching(:collections)
    end
    Capybara.reset_sessions!
    @test_data = EOL::TestInfo.load('collections')
    @collectable_collection = Collection.gen
    @collection = @test_data[:collection]
    @collection_owner = @test_data[:user]
    @user = nil
    @under_privileged_user = User.gen
    @anon_user = User.gen(:password => 'password')
    @taxon = @test_data[:taxon_concept_1]
    builder = EOL::Solr::CollectionItemsCoreRebuilder.new()
    builder.begin_rebuild
  end

  shared_examples_for 'collections and collecting all users' do
    it 'should be able to view a collection and its items' do
      visit collection_path(@collection)
      body.should have_tag('h1', /#{@collection.name}/)
      body.should have_tag('ul.object_list li', /#{@collection.collection_items.first.object.best_title}/)
    end

    it "should be able to sort a collection's items" do
      visit collection_path(@collection)
      body.should have_tag('#sort_by')
    end

    describe "should be able to collect" do
      it 'taxa' do
        it_should_collect_item(taxon_overview_path(@taxon), @taxon)
      end
      it 'data objects' do
        it_should_collect_item(data_object_path(@taxon.images.first), @taxon.images.first)
      end
      it 'communities' do
        new_community = Community.gen
        it_should_collect_item(community_path(new_community), new_community)
      end
      it 'collections, unless its their watch collection' do
        it_should_collect_item(collection_path(@collectable_collection), @collectable_collection)
        unless @user.nil?
          visit collection_path(@user.watch_collection)
          body.should_not have_tag('input[value=?]', 'Add to my collection')
        end
      end
      it 'users' do
        new_user = User.gen
        it_should_collect_item(user_path(new_user), new_user)
      end
    end
  end

  # Make sure you are logged in prior to calling this shared example group
  shared_examples_for 'collections and collecting logged in user' do
    it_should_behave_like 'collections and collecting all users'

    it 'should be able to select all collection items on the page' do
      visit collection_path(@collection)
      body.should_not have_tag("input[id=?][checked]", "collection_item_#{@collection.collection_items.first.id}")
      visit collection_path(@collection, :commit_select_all => true) # FAKE the button click, since it's JS otherwise
      body.should have_tag("input[id=?][checked]", "collection_item_#{@collection.collection_items.first.id}")
    end

    it 'should be able to copy collection items to one of their existing collections' do
      visit collection_path(@collection, :commit_select_all => true) # Select all button is JS, fake it.
      click_button 'Copy selected'
      body.should have_tag('#collections') do
        with_tag('input[value=?]', @user.watch_collection.name)
      end
    end

    it 'should be able to copy collection items to a new collection' do
      visit collection_path(@collection, :commit_select_all => true) # Select all button is JS, fake it.
      click_button 'Copy selected'
      body.should have_tag('#collections') do
        with_tag('form.new_collection')
      end
    end
  end

  describe 'anonymous users' do
    before(:all) { visit logout_url }
    subject { body }
    it_should_behave_like 'collections and collecting all users'
    it 'should not be able to select collection items' do
      visit collection_path(@collection)
      should_not have_tag("input#collection_item_#{@collection.collection_items.first.id}")
      should_not have_tag('input[name=?]', 'commit_select_all')
    end
    it 'should not be able to copy collection items' do
      visit collection_path(@collection)
      should_not have_tag("input#collection_item_#{@collection.collection_items.first.id}")
      should_not have_tag('input[name=?]', 'commit_copy_collection_items')
    end
    it 'should not be able to move collection items' do
      visit collection_path(@collection)
      should_not have_tag("input#collection_item_#{@collection.collection_items.first.id}")
      should_not have_tag('input[name=?]', 'commit_move_collection_items')
    end
    it 'should not be able to remove collection items' do
      visit collection_path(@collection)
      should_not have_tag("input#collection_item_#{@collection.collection_items.first.id}")
      should_not have_tag('input[name=?]', 'commit_remove_collection_items')
    end
  end

  describe 'user without privileges' do
    before(:all) {
      @user = @under_privileged_user
      login_as @user
    }
    after(:all) { @user = nil }
    it_should_behave_like 'collections and collecting logged in user'
    it 'should not be able to move collection items' do
      visit collection_path(@collection)
      should_not have_tag("input#collection_item_#{@collection.collection_items.first.id}")
      should_not have_tag('input[name=?]', 'commit_move_collection_items')
    end
    it 'should not be able to remove collection items' do
      visit collection_path(@collection)
      should_not have_tag("input#collection_item_#{@collection.collection_items.first.id}")
      should_not have_tag('input[name=?]', 'commit_remove_collection_items')
    end
  end

  describe 'user with privileges' do
    before(:all) {
      @user = @collection_owner
      login_as @user
    }
    after(:all) { @user = nil }
    it_should_behave_like 'collections and collecting logged in user'
    it 'should be able to move collection items'
    it 'should be able to remove collection items'
    it 'should be able to edit ordinary collection and nested collection item attributes' do
      visit collection_path(@collection)
      click_link 'edit name'
      page.fill_in 'collection_name', :with => 'Edited collection name'
      click_button 'Save'
      body.should have_tag('h1', 'Edited collection name')
    end
    it 'should not be able to edit special collections (really?)'
    it 'should be able to delete ordinary collections'
    it 'should not be able to delete special collections'
  end

end

#TODO: test connection with Solr: filter, sort, total results, paging, etc