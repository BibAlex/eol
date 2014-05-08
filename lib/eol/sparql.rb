# TODO - there is a lot of logic here that has more to do with URIs than with Sparql. Extract a class, pass instances of that around instead of
# a string.
module EOL
  module Sparql

    BASIC_URI_REGEX = /^http:\/\/[^ ]+$/i
    ENCLOSED_URI_REGEX = /^<(http:\/\/[^ ]+)>$/i
    NAMESPACED_URI_REGEX = /^([a-z0-9_-]{1,30}):([a-z0-9_-]+)$/i
    NAMESPACES = {
        'eol' => Rails.configuration.uri_prefix,
        'eolterms' => Rails.configuration.uri_term_prefix,
        'eolreference' => Rails.configuration.uri_reference_prefix,
        'dwc' => 'http://rs.tdwg.org/dwc/terms/',
        'dwct' => 'http://rs.tdwg.org/dwc/dwctype/',
        'dc' => 'http://purl.org/dc/terms/',
        'rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
        'rdfs' => 'http://www.w3.org/2000/01/rdf-schema#',
        'foaf' => 'http://xmlns.com/foaf/0.1/',
        'obis' => 'http://iobis.org/schema/terms/',
        'owl' => 'http://www.w3.org/2002/07/owl#',
        'anage' => 'http://anage.org/schema/terms/'
      }

    # NOTE - yes, this appears to be rebuilding the connection every time, but when I benchmarked it, it was very, very fast, so I'm not
    # worried about that.
    def self.connection
      @@connection ||= EOL::Sparql::VirtuosoClient.new(
        :endpoint_uri => $VIRTUOSO_SPARQL_ENDPOINT_URI,
        :upload_uri => $VIRTUOSO_UPLOAD_URI,
        :username => $VIRTUOSO_USER,
        :password => $VIRTUOSO_PW)
    end

    # camelCase (with starting lower) seems to be more standard for these, but we prefer underscores, soooo...
    def self.to_underscore(str)
      convert(str.strip.downcase.gsub(/\s+/, '_'))
    end

    def self.uri_to_readable_label(uri)
      return if KnownUri.taxon_concept_id(uri)
      if is_uri?(uri) && matches = uri.to_s.match(/(\/|#)([a-z0-9,_-]{1,})$/i)
        return matches[2].underscore.tr('_', ' ').capitalize_all_words
      end
    end

    def self.explicit_measurement_uri_components(unit_of_measure_uri)
      return uri_components(unit_of_measure_uri) if is_known_unit_of_measure_uri?(unit_of_measure_uri)
    end

    def self.implicit_measurement_uri_components(attribute_uri)
      if measurement_uri = implied_unit_of_measure_for_uri(attribute_uri)
        return uri_components(measurement_uri)
      end
    end

    def self.implied_unit_of_measure_for_uri(known_uri_or_string)
      if known_uri_or_string.is_a?(KnownUri) && ! known_uri_or_string.unit_of_measure?
        return known_uri_or_string.implied_unit_of_measure
      end
    end

    def self.is_known_unit_of_measure_uri?(known_uri_or_string)
      if known_uri_or_string.is_a?(KnownUri) && known_uri_or_string.unit_of_measure?
        return true
      end
    end

    def self.uri_components(known_uri_or_string)
      DataValue.new(known_uri_or_string)
    end

    def self.is_uri?(string)
      return true if string =~ BASIC_URI_REGEX
      return true if string =~ ENCLOSED_URI_REGEX
      return true if string =~ NAMESPACED_URI_REGEX
      false
    end

    def self.enclose_value(value)
      return "<" + value + ">" if value =~ BASIC_URI_REGEX
      return value if value =~ ENCLOSED_URI_REGEX || value =~ NAMESPACED_URI_REGEX
      "\"" + value + "\""
    end

    # Puts URIs in <brackets>, dereferences namespaces, and quotes literals.
    def self.expand_namespaces(input)
      value = input.to_s
      if value =~ BASIC_URI_REGEX                              # full URI
        return value
      elsif matches = value.match(ENCLOSED_URI_REGEX)          # full URI
        return matches[1]
      elsif matches = value.match(NAMESPACED_URI_REGEX)        # namespace
        if full_uri = EOL::Sparql::NAMESPACES[matches[1].downcase]
          return full_uri + matches[2]
        else
          return false  # this is the failure - an unknown namespace was given
        end
      end
      return value                                             # literal value
    end

    def self.convert(input)
       str = CGI.escape_html(input) # This doesn't convert everything we want it to, sadly:
       str.gsub!("'", "&apos;")
       str.gsub!("\\", "")
       str.gsub!("\n", "")
       str.gsub!("\r", "")
       str
    end

    def self.count_triples_in_graph(graph_name)
      EOL::Sparql.connection.query("SELECT COUNT DISTINCT ?s ?p ?o FROM <" + graph_name + "> WHERE { ?s ?p ?o }").first.values.first.to_i
    end

    def self.uris_in_data(rows)
      uris  = rows.map { |row| row[:attribute] }.select { |attr| attr.is_a?(RDF::URI) }
      uris += rows.map { |row| row[:value] }.select { |attr| attr.is_a?(RDF::URI) }
      uris += rows.map { |row| row[:unit_of_measure_uri] }.select { |attr| attr.is_a?(RDF::URI) }
      uris += rows.map { |row| row[:statistical_method] }.select { |attr| attr.is_a?(RDF::URI) }
      uris += rows.map { |row| row[:life_stage] }.select { |attr| attr.is_a?(RDF::URI) }
      uris += rows.map { |row| row[:sex] }.select { |attr| attr.is_a?(RDF::URI) }
      uris.map(&:to_s).uniq
    end

  end
end
