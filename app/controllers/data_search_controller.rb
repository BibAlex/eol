#encoding: utf-8

class DataSearchController < ApplicationController

  include ActionView::Helpers::TextHelper

  before_filter :restrict_to_data_viewers
  before_filter :allow_login_then_submit, only: :download

  layout 'data_search'

  # TODO - optionally but preferentially pass in a known_uri_id (when we have it), to avoid the ugly URL
  def index
    @page_title = I18n.t('data_search.page_title')
    prepare_search_parameters(params)
    prepare_attribute_options
    prepare_suggested_searches

    respond_to do |format|
      format.html do
        if @taxon_concept && !TaxonData.is_clade_searchable?(@taxon_concept)
          flash.now[:notice] = I18n.t('data_search.notice.clade_too_big',
            taxon_name: @taxon_concept.title_canonical_italicized.html_safe,
            contactus_tech_path: contact_us_path(subject: 'Tech')).html_safe
        elsif @clade_has_no_data
          flash.now[:notice] = I18n.t('data_search.notice.clade_has_no_data',
            taxon_name: @taxon_concept.title_canonical_italicized.html_safe,
            contribute_path: cms_page_path('contribute', anchor: 'data')).html_safe
        end
        t = Time.now
        @results = TaxonData.search(@search_options.merge(page: @page, per_page: 30))
        @counts_of_values_from_search = TaxonData.counts_of_values_from_search(@search_options.merge(page: @page, per_page: 30))
        log_data_search(time_in_seconds: Time.now - t)
      end
    end
  end

  def download
    if session[:submitted_data]
      search_params = session.delete(:submitted_data)
    else
      search_params = params.dup
    end
    prepare_search_parameters(search_params)
    df = create_data_search_file
    flash[:notice] = I18n.t(:file_download_pending, link: user_data_downloads_path(current_user.id))
    Resque.enqueue(DataFileMaker, data_file_id: df.id)
    redirect_to user_data_downloads_path(current_user.id)
  end

  private

  def create_data_search_file
    DataSearchFile.create!(@data_search_file_options)
  end

  def prepare_search_parameters(options)
    @hide_global_search = true
    @querystring = options[:q]
    @attribute = options[:attribute]
    @attribute_missing = @attribute.nil? && params.has_key?(:attribute) 
    @sort = (options[:sort] && [ 'asc', 'desc' ].include?(options[:sort])) ? options[:sort] : 'desc'
    @unit = options[:unit].blank? ? nil : options[:unit]
    @min_value = (options[:min] && options[:min].is_numeric?) ? options[:min].to_f : nil
    @max_value = (options[:max] && options[:max].is_numeric?) ? options[:max].to_f : nil
    @page = options[:page] || 1
    @taxon_concept = TaxonConcept.find_by_id(options[:taxon_concept_id])
    # Look up attribute based on query
    unless @querystring.blank? || EOL::Sparql.connection.all_measurement_type_uris.include?(@attribute)
      @attribute_known_uri = KnownUri.by_name(@querystring).first
      if @attribute_known_uri
        @attribute = @attribute_known_uri.uri
        @querystring = options[:q] = ''
      end
    else
      @attribute_known_uri = KnownUri.find_by_uri(@attribute)
    end
    if @attribute_known_uri && ! @attribute_known_uri.units_for_form_select.empty?
      @units_for_select = @attribute_known_uri.units_for_form_select
    else
      @units_for_select = KnownUri.default_units_for_form_select
    end
    @search_options = { querystring: @querystring, attribute: @attribute, min_value: @min_value, max_value: @max_value,
      unit: @unit, sort: @sort, language: current_language, taxon_concept: @taxon_concept }
    @data_search_file_options = { q: @querystring, uri: @attribute, from: @min_value, to: @max_value,
      sort: @sort, known_uri: @attribute_known_uri, language: current_language,
      user: current_user, taxon_concept_id: (@taxon_concept ? @taxon_concept.id : nil),
      unit_uri: @unit }
  end

  # TODO - this should be In the DB with an admin/master curator UI behind it. I would also add a "comment" to that model, when
  # we build it, which would populate a flash message after the search is run; that would allow things like "notice how this
  # search specifies a URI as the query" and the like, calling out specific features of each search.
  #
  # That said, we will have to consider how to deal with I18n, both for the "comment" and for the label.
  def prepare_suggested_searches
    @suggested_searches = [
      { label_key: 'search_suggestion_whale_mass',
        params: {
          sort: 'desc',
          min: 10000,
          taxon_concept_id: 7649,
          attribute: 'http://purl.obolibrary.org/obo/VT_0001259',
          unit: 'http://purl.obolibrary.org/obo/UO_0000009' }},
      { label_key: 'search_suggestion_cavity_nests',
        params: {
          q: 'cavity',
          attribute: 'http://eol.org/schema/terms/NestType' }},
      { label_key: 'search_suggestion_diatom_shape',
        params: {
          attribute: 'http://purl.obolibrary.org/obo/OBA_0000052',
          taxon_concept_id: 3685 }},
      { label_key: 'search_suggestion_blue_flowers',
        params: {
          q: 'http://purl.obolibrary.org/obo/PATO_0000318',
          attribute: 'http://purl.obolibrary.org/obo/TO_0000537' }}
    ]
  end

  # todo improve this hacky way of handling empty attributes
  def prepare_attribute_options
    @attribute_options = []
    if @taxon_concept && TaxonData.is_clade_searchable?(@taxon_concept)
      # Get URIs (attributes) that this clade has measurements or facts for.
      # NOTE excludes associations URIs e.g. preys upon.
      measurement_uris = EOL::Sparql.connection.all_measurement_type_known_uris_for_clade(@taxon_concept)
      @attribute_options = convert_uris_to_options(measurement_uris)
      @clade_has_no_data = true if @attribute_options.empty?
    end

    if @attribute_options.empty?
      # NOTE - because we're pulling this from Sparql, user-added known uris may not be included. However, it's superior to
      # KnownUri insomuch as it ensures that KnownUris with NO data are ignored.
      measurement_uris = EOL::Sparql.connection.all_measurement_type_known_uris
      @attribute_options = convert_uris_to_options(measurement_uris)
    end

    if @attribute.nil?
      # NOTE we should (I assume) only get nil attribute when the user first
      #      loads the search, so for that context we select an example default,
      #      starting with [A-Z] seems more readable. If my assumption is wrong
      #      then we should rethink this and tell the user why attribute is nil
      match = @attribute_options.select{|o| o[0] =~ /^[A-Z]/}
      @attribute_default = match.first[1] unless match.empty?
    end
  end

  def convert_uris_to_options(measurement_uris)
    # TODO - this could be greatly simplified with duck-typing.  :|
    measurement_uris.collect do |uri|
      label = uri.respond_to?(:name) ? uri.name : EOL::Sparql.uri_to_readable_label(uri)
      if label.nil?
        nil
      else
        [ truncate(label.firstcap, length: 30),
          uri.respond_to?(:uri) ? uri.uri : uri,
          { 'data-known_uri_id' => uri.respond_to?(:id) ? uri.id : nil } ]
      end
    end.compact.sort_by{ |o| o.first }.uniq
  end

  # Add an entry to the database recording the number of results and time of search operation
  def log_data_search(options = {})
    # We are logging when there is only a TaxonConceptID - that will occur if a users clicks on a search
    # link from the data tab on a taxon page. In that case, a search is NOT performed, but we are
    # creating a log to capture the time it takes to populate the attribute list.
    # For every log which has an attribute, a search WILL have been performed
    if params[:attribute] || params[:taxon_concept_id]
      DataSearchLog.create(
        @data_search_file_options.merge({
          clade_was_ignored: (@taxon_concept && ! TaxonData.is_clade_searchable?(@taxon_concept)) ? true : false,
          user_id: ( logged_in? ? current_user.id : nil ),
          number_of_results: @results.total_entries,
          time_in_seconds: options[:time_in_seconds],
          ip_address: request.remote_ip
        })
      )
    end
  end


end
