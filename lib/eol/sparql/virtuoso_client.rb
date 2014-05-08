# NOTE - this uses a Rails logger, so you can't use this library outside of Rails, for the moment.
module EOL
  module Sparql
    class VirtuosoClient < Client

      attr_accessor :upload_uri

      # Virtuoso data is getting posted to upload_uri
      # see http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/VirtRDFInsert#HTTP POST Example 1
      def initialize(options = {})
        @upload_uri = options[:upload_uri]
        super(options)
      end

      def insert_data(options = {})
        unless options[:data].blank?
          query = "INSERT DATA INTO <#{options[:graph_name]}> { "+ options[:data].join(" .\n") +" }"
          uri = URI(upload_uri)
          request = Net::HTTP::Post.new(uri.request_uri)
          request.basic_auth(username, password)
          request.body = "#{namespaces_prefixes} #{query}"
          request.content_type = 'application/sparql-query'

          response = Net::HTTP.start(uri.host, uri.port) do |http|
            http.open_timeout = 30
            http.read_timeout = 240
            http.request(request)
          end

          if response.code.to_i != 201 && Rails.logger
            Rails.logger.error "** SOME DATA FAILED TO LOAD IN VIRTUOSO:"
            Rails.logger.error "** Graph: #{options[:graph_name]}"
            Rails.logger.error "** URI: #{uri.request_uri}"
            Rails.logger.error "** User: #{username}"
            Rails.logger.error "** Namespaces prefixes: #{namespaces_prefixes}"
            Rails.logger.error "** Query: #{query}"
          end
        end
      end
    end
  end
end
