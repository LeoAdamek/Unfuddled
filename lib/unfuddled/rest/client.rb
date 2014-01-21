require 'unfuddled'
require 'unfuddled/client'

require 'unfuddled/error'
require 'unfuddled/error/configuration_error'
require 'unfuddled/error/not_found_error'

require 'unfuddled/api/account'
require 'unfuddled/api/milestones'
require 'unfuddled/api/people'
require 'unfuddled/api/projects'
require 'unfuddled/api/tickets'
require 'unfuddled/api/time_tracking'

require 'faraday'
require 'faraday_middleware'
require 'json'

require 'memoizer'

module Unfuddled
  module REST
    class Client < Unfuddled::Client

      include Unfuddled::REST::API::Account
      include Unfuddled::REST::API::Milestones
      include Unfuddled::REST::API::People
      include Unfuddled::REST::API::Projects
      include Unfuddled::REST::API::Tickets
      include Unfuddled::REST::API::TimeTracking

      # Allow @connection_options and @middleware to be overridden
      attr_writer :connection_options, :middleware
      

      # Get Connection Options
      # 
      # @return [Hash] Options for the connection to the API
      def connection_options
        @connection_options ||= {
          :builder => middleware,
          :headers => {
            :accept => 'application/json',
            :user_agent => user_agent
          },
          :request => {
            :open_timeout => 5,
            :timeout => 10
          }
        }
      end

      # Get Middleware
      #
      # @return [Faraday::Builder]
      def middleware
        @middleware ||= ::Faraday::Builder.new do |builder|
          # Retry network failed requests
          builder.request :retry

          # Use Faraday's Basic HTTP Autentication
          builder.use Faraday::Request::BasicAuthentication , credentials[:username] , credentials[:password]

          # Make requests encoded as JSON
          builder.request :json

          # Parse responses with Json
          builder.response :json , :content_type => /\bjson$/

          # Use the ruby built in 'net/http' adapter
          builder.adapter :net_http
        end
      end
      
      # Get the endpoint
      #
      # @return [String]
      def endpoint
        "https://#{credentials[:subdomain]}.unfuddle.com/api/v1"
      end

      # Perform HTTP GET Request
      #
      # @param path   [String] Request Path
      # @param params [Hash]   Request Parameters
      def get(path , params = {})
        request(:get , path , params)
      end

      # Perform HTTP POST Request
      #
      # @param path   [String] Request Path
      # @param params [Hash]   Request Prameters
      def post(path, params = {})
        request(:post , path, params)
      end

      # Get a connnection
      #
      # @return [Faraday::Connection]
      private
      def connection
        @connection ||= Faraday.new( endpoint , connection_options )
      end

      # Make a request
      #
      # @param method [String,Symbol] HTTP Request Verb
      # @param path   [String] Path of Request
      # @param params [Hash]   Request parameters
      private
      def request(method , path, params = {})

        response = connection.send(method.to_sym , path, params) do |request|
          request.headers.update(request_headers(method, path, params))
        end

        raise Unfuddled::NotFoundError.new if response.status == 404

        response.env
      rescue Faraday::Error::ClientError, JSON::ParserError => error
        error = Unfuddled::Error.new(error)
        raise error
      end
                                 
      # Get Request Headers
      #
      # @param method [String,Symbol] HTTP Request Verb
      # @param path   [String] HTTP Request Path
      # @param params [Hash]   Hash of Request parameters
      private
      def request_headers(method, path, params = {})
        headers = {
          :accept => 'application/json',
          :content_type => 'application/json; charset=UTF-8'
        }
      end

      # Process a list response
      #
      # Makes sure response is always an array of klass,
      # even if there is only one item
      public
      def process_list_response(response_body , klass = Unfuddled::Base)
        if response_body.is_a?(Hash)
          results = [ klass.from_response( response_body , self) ]
        else
          results = []
          response_body.each do |response_item|
            results << klass.from_response( response_item , self)
          end
        end

        results
          
      end
                          
    end
  end
end
            
