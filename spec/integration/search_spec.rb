require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../../lib/eol_data'
class EOL::NestedSet; end
EOL::NestedSet.send :extend, EOL::Data

require 'solr_api'

def assert_results(options)
  search_string = options[:search_string] || 'tiger'
  per_page = options[:per_page] || 10
  visit("/search?q=#{search_string}&per_page=#{per_page}#{options[:page] ? "&page=#{options[:page]}" : ''}")
  body.should have_tag('#search_results ul') do
    header_index = 1
    result_index = header_index + options[:num_results_on_this_page]
    with_tag("li:nth-child(#{result_index})")
    without_tag("li:nth-child(#{result_index + 1})").should be_false
  end
end

describe 'Search' do

    before :all do
      truncate_all_tables
      load_scenario_with_caching(:search_names)
      data = EOL::TestInfo.load('search_names')

      @panda_name               = data[:panda_name]
      @panda                    = data[:panda]
      @tiger_name               = data[:tiger_name]
      @tiger                    = data[:tiger]
      @tiger_lilly_name         = data[:tiger_lilly_name]
      @tiger_lilly              = data[:tiger_lilly]
      @plantain_name            = data[:plantain_name]
      @plantain_common          = data[:plantain_common]
      @plantain_synonym         = data[:plantain_synonym]
      @dog_name                 = data[:dog_name]
      @domestic_name            = data[:domestic_name]
      @dog_sci_name             = data[:dog_sci_name]
      @wolf_name                = data[:wolf_name]
      @tricky_search_suggestion = data[:tricky_search_suggestion]

      Capybara.reset_sessions!
      visit('/logout')
      visit('/content_partner/logout')
      make_all_nested_sets
      flatten_hierarchies
      @solr = SolrAPI.new($SOLR_SERVER, $SOLR_SITE_SEARCH_CORE)
      @solr.delete_all_documents
      TaxonConcept.all.each do |tc|
        tc.save
      end

      visit("/search?q=#{@tiger_name}")
      @tiger_search = body
    end

    it 'should redirect to species page if only 1 possible match is found (also for pages/searchterm)' do
      visit("/search?q=#{@panda_name}")
      current_path.should match /\/pages\/#{@panda.id}/
      visit("/search/#{@panda_name}")
      current_path.should match /\/pages\/#{@panda.id}/
    end

    it 'should redirect to search page if a string is passed to a species page' do
      visit("/pages/#{@panda_name}")
      current_path.should match /\/pages\/#{@panda.id}/
    end

    it 'should show a list of possible results (linking to /found) if more than 1 match is found  (also for pages/searchterm)' # do
    #       body = @tiger_search
    #       body.should have_tag('li', /#{@tiger_name}/) do
    #         with_tag('a[href*=?]', %r{/pages/#{@tiger.id}})
    #       end
    #       body.should have_tag('li', /#{@tiger_lilly_name}/) do
    #         with_tag('a[href*=?]', %r{/pages/#{@tiger_lilly.id}})
    #       end
    #     end

    it 'should paginate' # do
#      results_per_page = 2
#      extra_results    = 1
#      assert_results(:num_results_on_this_page => results_per_page, :per_page => results_per_page)
#      assert_results(:num_results_on_this_page => extra_results, :page => 2, :per_page => results_per_page)
#    end

    it 'return no suggested results for tiger (NEEDS REVIEWING - suggested search is not separate in V2 design)' # do
#      body = @tiger_search
#      body.should_not have_tag('table[summary=Suggested Search Results]')
#    end

    it 'should return one suggested search' do
      visit("/search?q=#{URI.escape @plantain_name.gsub(/ /, '+')}&search_type=text")
      body.should have_tag("#search_results li", /#{@plantain_common}/)
    end

    # When we first created suggested results, it worked fine for one, but failed for two, so we feel we need to test
    # two entires AND one entry...
    it 'should return two suggested searches' # do
    #       visit("/search?q=#{@dog_name}&search_type=text")
    #       body.should have_tag('#search_results ul') do
    #         with_tag("li", /#{@domestic_name}/)
    #         with_tag("li", /#{@wolf_name}/)
    #       end
    #     end

    it 'should be able to return suggested results for "bacteria"' # do
    #       visit("/search?q=#{@tricky_search_suggestion}&search_type=text")
    #       body.should have_tag("#search_results li", /#{@tricky_search_suggestion}/)
    #     end

    it 'should treat empty string search gracefully when javascript is switched off' do
      visit('/search?q=')
      body.should_not include "500 Internal Server Error"
    end

    it 'should detect untrusted and unknown Taxon Concepts (NOT INDICATED IN V2 DESIGN)' # do
#      body = @tiger_search
#      body.should match /td class=("|')(search_result_cell )?(odd|even)_untrusted/
#      body.should match /td class=("|')(search_result_cell )?(odd|even)_unvetted/
#    end

    it 'should show only common names which include whole search query' # do
    #       visit("/search?q=#{URI.escape @tiger_lilly_name}")
    #       # should find only common names which have 'tiger lilly' in the name
    #       # we have only one such record in the test, so it redirects directly
    #       # to the species page
    #       current_path.should match /\/pages\/#{@tiger_lilly.id}/
    #     end

    it 'should return preferred common name as "shown" name (NOT SURE ABOUT THIS ONE)' # do
#      visit("/search?q=panther")
#      body.should include "shown as 'Tiger lilly'"
#    end

    it 'should show "shown as" for scientific matches that hit a synonym (NOT SURE ABOUT THIS ONE).' # do
#      visit("/search?q=#{@plantain_synonym.split[0]}")
#      body.should include @plantain_synonym
#      body.should include "shown as '#{@plantain_name}'"
#    end

    it 'should return a helpful message if no results' do
      # TaxonConcept.should_receive(:search_with_pagination).at_least(1).times.and_return([])
      visit("/search?q=bozo")
      body.should have_tag('h2', /0 results for.*?bozo/)
    end

    it 'should be able to sort results'
    it 'should be able to filter results by type'

end
