# Put a few taxa (all within a new hierarchy) in the database with a range of accoutrements
#
#   TODO add a description here of what actually gets created!
#
#   This description block can be viewed (as well as other information
#   about this scenario) by running:
#     $ rake scenarios:show NAME=bootstrap
#
#---
#dependencies: [ :foundation ]

$CACHE.clear # Not *positive* we need this, but...
require 'spec/eol_spec_helpers'
require 'spec/scenario_helpers'
# This gives us the ability to build taxon concepts:
include EOL::Spec::Helpers


load_foundation_cache

collections = {}
collections[:taxon_concept_1] = build_taxon_concept
collections[:taxon_concept_2] = build_taxon_concept
collections[:user] = User.gen
collections[:user2] = User.gen
collections[:community] = Community.gen
collections[:collection] = Collection.gen(:user => collections[:user])
collections[:collection_oldest] = Collection.gen(:user => collections[:user], :created_at => collections[:collection].created_at - 86400)
collections[:data_object] = DataObject.last
collections[:taxon_concept] = build_taxon_concept(:images => [{}]) # One image
collections[:collection].add(collections[:data_object]) # Added the data object as a collection item to the collection

collections[:before_all_check] = User.gen(:username => 'collections_scenario')

EOL::TestInfo.save('collections', collections)
