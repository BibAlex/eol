require "spec_helper"

describe 'taxa/data/index' do

  def assign_nothing
    assign(:assistive_section_header, 'whatever')
    assign(:recently_used, nil)
    assign(:taxon_page, @taxon_page)
    assign(:taxon_data, @taxon_page.data)
    @data = TaxonDataSet.new([])
    @data.stub(:empty?).and_return(false)
    assign(:data_point_uris, @data)
    assign(:toc_id, nil)
    assign(:selected_data_point_uri_id, nil)
    assign(:categories, TocItem.for_uris(Language.english).select{ |toc| @taxon_page.data.categories.include?(toc) })
    assign(:toc_id, nil)
    assign(:supress_disclaimer, true)
    assign(:range_data, [])
    assign(:glossary_terms, [])
    assign(:units_for_select, KnownUri.default_units_for_form_select)
  end

  before(:all) do
    Visibility.create_enumerated
    Vetted.create_enumerated
    CuratorLevel.create_enumerated
    KnownUri.create_enumerated
    UriType.create_enumerated
    License.create_enumerated
    ContentPartnerStatus.create_enumerated
    Language.create_english # :\
    @anonymous = EOL::AnonymousUser.new('en')
    @curator = FactoryGirl.create(:curator)
    @taxon = TaxonConcept.gen()
  end

  before(:each) do
    view.stub(:meta_open_graph_data).and_return([])
    view.stub(:tweet_data).and_return({})
  end

  describe '(logged out)' do

    before(:each) do
      @taxon_page = TaxonUserClassificationFilter.new(@taxon, @anonymous)
      view.stub(:current_user).and_return(@anonymous)
      assign_nothing
    end

    it 'should NOT show the key' do
      render
      expect(rendered).not_to include(I18n.t(:data_tab_curator_key_exemplar, image: "", link: taxon_overview_path(@taxon_page)))
    end

  end

  describe '(as a full curator)' do

    before(:each) do
      @taxon_page = TaxonUserClassificationFilter.new(@taxon, @curator)
      view.stub(:current_user).and_return(@curator)
      assign_nothing
    end

    it 'should show the key' do
      render
      expect(rendered).to include(I18n.t(:data_tab_curator_key_exemplar, image: "", link: taxon_overview_path(@taxon_page)))
    end

  end

  context 'logged in with data' do

    before(:each) do
      @taxon_concept = build_stubbed(TaxonConcept)
      @taxon_concept.stub(:latest_version) { @taxon_concept }
      taxon_data = double(TaxonData, taxon_concept: @taxon_concept, bad_connection?: false)
      taxon_data.stub(:get_data) { [] }
      taxon_page = double(TaxonPage)
      taxon_page.stub(:scientific_name) { 'Arspecius viewicaa' }
      assign(:taxon_page, taxon_page)
      assign(:taxon_data, taxon_data)
      assign(:toc_id, nil)
      assign(:selected_data_point_uri_id, nil)
      assign(:supress_disclaimer, true) # I don't even know what this is.  remove it?
      assign(:assistive_section_header, 'assist my taxon_data')
      assign(:categories, [])
      assign(:data_point_uris, [])
      assign(:glossary_terms, [])
      assign(:range_data, [])
      assign(:include_other_category, true)
      assign(:units_for_select, KnownUri.default_units_for_form_select)
      user = build_stubbed(User)
      user.stub(:can_see_data?) { true }
      view.stub(:current_user) { user }
      view.stub(:current_language) { Language.default }
      view.stub(:logged_in?) { false }
      view.stub(:is_clade_searchable?) { true }
    end

    context 'with data' do

      before(:each) do
        @chucks = FactoryGirl.build(:known_uri_unit)
        tku = FactoryGirl.build(:translated_known_uri, name: 'chucks', known_uri: @chucks)
        taxon_concept = build_stubbed(TaxonConcept)
        dpu = DataPointUri.gen(unit_of_measure_known_uri: @chucks,
                              object: "2.354",
                              taxon_concept: taxon_concept,
                              vetted: Vetted.trusted,
                              visibility: Visibility.visible)
        assign(:data_point_uris, [dpu])
      end

      it "should NOT show units when undefined" do
        render
        expect(rendered).to_not have_tag('span', text: /chucks/)
      end

      it "should show units when defined" do
        EOL::Sparql.should_receive(:explicit_measurement_uri_components).with(@chucks).and_return(DataValue.new('chucks'))
        render
        expect(rendered).to have_tag('span', text: /chucks/)
      end

      it "should show statistical method" do
        assign(:data_point_uris, [ DataPointUri.gen(predicate: 'Itspredicate', statistical_method: 'Itsmethod') ])
        render
        expect(rendered).to have_tag('span.stat', text: /Itsmethod/)
      end

      it "should show life stage" do
        assign(:data_point_uris, [ DataPointUri.gen(life_stage: 'Itslifestage') ])
        render
        expect(rendered).to have_tag('span.stat', text: /Itslifestage/)
      end

      it "should show sex" do
        assign(:data_point_uris, [ DataPointUri.gen(sex: 'Itssex') ])
        render
        expect(rendered).to have_tag('span.stat', text: /Itssex/)
      end

      it "should show sex and life stage together" do
        assign(:data_point_uris, [ DataPointUri.gen(life_stage: 'Itslifestage', sex: 'Itssex') ])
        render
        expect(rendered).to have_tag('span.stat', text: /Itslifestage, Itssex/)
      end

    end

  end

end
