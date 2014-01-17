module EOL
  module Sparql
    class SearchQueryBuilder

      def initialize(options)
        options.each { |k,v| instance_variable_set("@#{k}", v) }
        @per_page ||= TaxonData::DEFAULT_PAGE_SIZE
        @page ||= 1
      end

      # Class method to build a query
      # This is likely the only thing that will get called outside this class
      def self.prepare_search_query(options)
        builder = EOL::Sparql::SearchQueryBuilder.new(options)
        builder.prepare_query
      end

      # Basic query assembler
      def self.build_query(select, where, order, limit)
        "#{ select } WHERE {
            #{ where }
          }
          #{ order ? order : '' }
          #{ limit ? limit : '' }"
      end

      # To add a taxon filter, the current best way is to do a UNION of the results
      # of data for a taxon, and results for the descendants of the taxon - not
      # doing some kind of conditional
      def self.build_query_with_taxon_filter(taxon_concept_id, select, where, order)
        "{
          #{ select } WHERE {
            #{ where } .
            ?parent_taxon dwc:taxonConceptID <#{UserAddedData::SUBJECT_PREFIX}#{taxon_concept_id}> .
            ?parent_taxon dwc:taxonConceptID ?parent_taxon_concept_id .
            ?t dwc:parentNameUsageID+ ?parent_taxon .
            ?t dwc:taxonConceptID ?taxon_concept_id
          }
          #{ order ? order : '' }
        } UNION {
          #{ select } WHERE {
            #{ where } .
            ?taxon_id dwc:taxonConceptID <#{UserAddedData::SUBJECT_PREFIX}#{taxon_concept_id}>
          }
          #{ order ? order : '' }
        }"
      end

      # Instance method to put together all the pieces and return a string
      # representing the final Sparql search query
      def prepare_query
        if @taxon_concept && TaxonData.is_clade_searchable?(@taxon_concept)
          inner_query = EOL::Sparql::SearchQueryBuilder.build_query_with_taxon_filter(@taxon_concept.id, inner_select_clause, where_clause, order_clause)
        else
          inner_query = EOL::Sparql::SearchQueryBuilder.build_query(inner_select_clause, where_clause, order_clause, nil)
        end
        # this is strange, but in order to properly do sorts, limits, and offsets there should be a subquery
        # see http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/VirtTipsAndTricksHowToHandleBandwidthLimitExceed
        EOL::Sparql::SearchQueryBuilder.build_query(outer_select_clause, inner_query, nil, limit_clause)
      end

      def where_clause
        "GRAPH ?graph {
            ?data_point_uri dwc:measurementType ?attribute .
          } .
          ?data_point_uri dwc:measurementValue ?value .
          ?data_point_uri eol:measurementOfTaxon ?measurementOfTaxon .
          ?data_point_uri dwc:occurrenceID ?occurrence_id .
          ?occurrence_id dwc:taxonID ?taxon_id .
          ?taxon_id dwc:taxonConceptID ?taxon_concept_id .
          OPTIONAL { ?occurrence_id dwc:lifeStage ?life_stage } .
          OPTIONAL { ?occurrence_id dwc:sex ?sex } .
          OPTIONAL { ?data_point_uri dwc:measurementUnit ?unit_of_measure_uri } .
          OPTIONAL { ?data_point_uri eolterms:statisticalMethod ?statistical_method } .
          FILTER ( ?measurementOfTaxon = 'true' ) .
          #{ filter_clauses }
          #{ attribute_filter }"
      end

      def outer_select_clause
        @only_count ?
          "SELECT COUNT(*) as ?count" :
          "SELECT DISTINCT ?attribute ?value ?unit_of_measure_uri ?statistical_method ?life_stage ?sex ?data_point_uri ?graph ?taxon_concept_id"
      end

      def inner_select_clause
        @only_count ?
          "SELECT DISTINCT ?data_point_uri" :
          "SELECT ?attribute ?value ?unit_of_measure_uri ?statistical_method ?life_stage ?sex ?data_point_uri ?graph ?taxon_concept_id"
      end

      def filter_clauses
        filter_clauses = ""
        # numerical range search with units
        if @unit && (@min_value || @max_value)
          builder = EOL::Sparql::UnitQueryBuilder.new(@unit, @min_value, @max_value)
          filter_clauses += builder.sparql_query_filters
        # numerical range search term
        elsif @min_value || @max_value
          filter_clauses += "FILTER(xsd:float(?value) >= xsd:float(#{ @min_value })) . " if @min_value
          filter_clauses += "FILTER(xsd:float(?value) <= xsd:float(#{ @max_value })) . " if @max_value
        # exact numerical search term
        elsif @querystring && @querystring.is_numeric?
          filter_clauses += "FILTER(xsd:float(?value) = xsd:float(#{ @querystring })) . "
        # string search term
        elsif @querystring && ! @querystring.strip.empty?
          matching_known_uris = KnownUri.search(@querystring)
          filter_clauses += "FILTER(( REGEX(?value, '(^|\\\\W)#{ @querystring }(\\\\W|$)', 'i'))"
          unless matching_known_uris.empty?
            filter_clauses << " || ?value IN (<#{ matching_known_uris.collect(&:uri).join('>,<') }>)"
          end
          filter_clauses += ") . "
        end
        filter_clauses
      end

      def limit_clause
        @only_count ? "" : "LIMIT #{ @per_page } OFFSET #{ ((@page.to_i - 1) * @per_page) }"
      end

      def order_clause
        unless @only_count
          if @sort == 'asc'
            return "ORDER BY ASC(xsd:float(?value)) ASC(?value)"
          elsif @sort == 'desc'
            return "ORDER BY DESC(xsd:float(?value)) DESC(?value)"
          end
        end
        ""
      end

      def attribute_filter
        @attribute ? "FILTER(?attribute = <#{ @attribute }>)" : ""
      end
    end
  end
end