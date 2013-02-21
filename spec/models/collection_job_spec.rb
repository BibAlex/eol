require File.dirname(__FILE__) + '/../spec_helper'

describe CollectionJob do

  # TODO - custom matcher
  def collection_should_include(collection, item)
    collection.collection_items.map(&:collected_item).should include(item)
  end
  def collection_should_not_include(collection, item)
    collection.collection_items.map(&:collected_item).should_not include(item)
  end

  before(:all) do
    # We don't need the full foundation for this stuff...
    DataType.create_defaults
    License.create_defaults
  end

  describe 'class methods' do

    # This looks like a lot of setup, but it's actually really simple stuff; don't be intimidated. Collections have
    # lots of items.  :)
    before(:each) do
      @user = User.gen
      @has_source_but_not_target = User.gen
      @has_target_but_not_source = User.gen
      @source = Collection.gen
      @tc = TaxonConcept.gen
      @tc.stub(:scientific_name).and_return('Ambiguii nomenclatura')
      @source_tc = @source.add @tc
      @dato = DataObject.gen(:object_title => 'Image of your mom')
      @source_dato = @source.add @dato
      @source_collection = @source.add @collection = Collection.gen
      @source_person = @source.add @person = User.gen
      @user.collections << @source
      @has_source_but_not_target.collections << @source
      @target = Collection.gen
      @target.add @tc
      @target.add @dato
      @user.collections << @target
      @has_target_but_not_source.collections << @target
      # The following assuptions are used in multiple specs, so we check them universally:
      @source.collection_items.count.should == 4
      @target.collection_items.count.should == 2
      collection_should_not_include(@target, @collection)
      collection_should_not_include(@target, @person)
    end

    it 'should copy from one collection to another without copying duplicates' do
      job = CollectionJob.copy(:user => @user, :source => @source, :target => @target,
                                :collection_item_ids => [@source_tc.id, @source_dato.id, @source_collection.id])
      @source.reload.collection_items.count.should == 4 # nothing got removed?
      @target.reload.collection_items.count.should == 3 # only one thing was added?
      collection_should_include(@target, @collection)
      job.item_count.should == 1 # Because only one of the four actually got copied.
    end

    it 'should move from one collection to another without moving duplicates' do
      job = CollectionJob.move(:user => @user, :source => @source, :target => @target,
                               :collection_item_ids => [@source_tc.id, @source_dato.id, @source_collection.id])
      @source.reload.collection_items.count.should == 3 # only one thing should actually have moved.
      @target.reload.collection_items.count.should == 3 # only one thing was added?
      collection_should_include(@source, @tc) # Dupe, should have stayed.
      collection_should_include(@source, @dato) # Dupe, should have stayed.
      collection_should_not_include(@source, @collection)
      collection_should_include(@target, @tc)
      collection_should_include(@target, @dato)
      collection_should_include(@target, @collection)
      job.item_count.should == 1 # THIS ONE FAILS... re-write the algo to manually count.
    end

    it 'should remove items from a collection' do
      job = CollectionJob.remove(:user => @user, :source => @source,
                                  :collection_item_ids => [@source_tc.id, @source_dato.id, @source_collection.id])
      @source.reload.collection_items.count.should == 1
      collection_should_include(@source, @person)
      collection_should_not_include(@source, @tc)
      collection_should_not_include(@source, @dato)
      collection_should_not_include(@source, @collection)
      job.item_count.should == 3
    end

    # NOTE - all_items uses different algorithms, and we want to ensure they still work, so they are tested separately:
    it 'should copy all items from one collection to another without copying duplicates' do
      job = CollectionJob.copy(:user => @user, :source => @source, :target => @target, :all_items => true)
      @source.reload.collection_items.count.should == 4 # nothing got removed?
      @target.reload.collection_items.count.should == 4
      collection_should_include(@target, @collection)
      collection_should_include(@target, @person)
      job.item_count.should == 2
    end

    it 'should move all items from one collection to another without moving duplicates' do
      job = CollectionJob.move(:user => @user, :source => @source, :target => @target, :all_items => true)
      @source.reload.collection_items.count.should == 2
      @target.reload.collection_items.count.should == 4
      collection_should_include(@source, @tc) # Dupe, should have stayed.
      collection_should_include(@source, @dato) # Dupe, should have stayed.
      collection_should_not_include(@source, @collection)
      collection_should_not_include(@source, @person)
      collection_should_include(@target, @tc)
      collection_should_include(@target, @dato)
      collection_should_include(@target, @collection)
      collection_should_include(@target, @person)
      job.item_count.should == 2 # THIS ONE FAILS... re-write the algo to manually count.
    end

    it 'should remove all items items from a collection' do
      job = CollectionJob.remove(:user => @user, :source => @source, :all_items => true)
      @source.reload.collection_items.count.should == 0
      collection_should_not_include(@source, @person)
      collection_should_not_include(@source, @tc)
      collection_should_not_include(@source, @dato)
      collection_should_not_include(@source, @collection)
      job.item_count.should == 4
    end


    # NOTE - this is a weird test, because it *actually* fails for permissions (can't edit nil), but the effect is desirable:
    it 'should raise an exception if copying without a target' do
      lambda do
        CollectionJob.copy(:user => @user, :source => @source, :target => nil, :all_items => true)
      end.should raise_error
    end

    # NOTE - this is a weird test, because it *actually* fails for permissions (can't edit nil), but the effect is desirable:
    it 'should raise an exception if moving without a target' do
      lambda do
        CollectionJob.move(:user => @user, :source => @source, :target => nil, :all_items => true)
      end.should raise_error
    end

    it 'should raise an exception if attempting to remove from an unowned source' do
      lambda do
        CollectionJob.remove(:user => @has_target_but_not_source, :source => @source, :all_items => true)
      end.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should raise an exception if attempting to move from an unowned source' do
      lambda do
        CollectionJob.move(:user => @has_target_but_not_source, :source => @source, :target => @target, :all_items => true)
      end.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should raise an exception if attempting to move to an unowned target' do
      lambda do
        CollectionJob.move(:user => @has_source_but_not_target, :source => @source, :target => @target, :all_items => true)
      end.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should raise an exception if attempting to copy to an unowned target' do
      lambda do
        CollectionJob.copy(:user => @has_source_but_not_target, :source => @source, :target => @target, :all_items => true)
      end.should raise_error(EOL::Exceptions::SecurityViolation)
    end

    it 'should raise an exception if attempting anything with no items and not all_items' do
      lambda do
        CollectionJob.copy(:user => @user, :source => @source, :target => @target)
      end.should raise_error(EOL::Exceptions::CollectionJobRequiresScope)
      lambda do
        CollectionJob.move(:user => @user, :source => @source, :target => @target)
      end.should raise_error(EOL::Exceptions::CollectionJobRequiresScope)
      lambda do
        CollectionJob.remove(:user => @user, :source => @source)
      end.should raise_error(EOL::Exceptions::CollectionJobRequiresScope)
    end

    it 'should recalculate the relevances and reindex solr after a copy'
    it 'should recalculate the relevances and reindex solr after a move'
    it 'should recalculate the relevance and reindex solr after a remove'

    # Possibly premature:
    it 'should remove caches after a copy'
    it 'should remove caches after a move'
    it 'should remove caches after a remove'

  end

  # Requires some knowledge of private methods, alas, but they are important checks:
  describe '#run' do

    before(:each) do
      @copy = CollectionJob.gen(:command => 'copy')
      @copy_all = CollectionJob.gen(:all_items => true, :command => 'copy')
    end

    it 'should call #copy_all if all items' do
      @copy_all.should_receive(:copy_all).and_return(23)
      @copy_all.run
      @copy_all.item_count.should == 23
    end

    it 'should call #copy_some if NOT all items' do
      @copy.should_receive(:copy_some).and_return(24)
      @copy.run
      @copy.item_count.should == 24
    end

    it 'should call #move_all if all items'
    it 'should call #move_some if NOT all items'
    it 'should call #remove_all if all items'
    it 'should call #remove_some if NOT all items'

  end

end