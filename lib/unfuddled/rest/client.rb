require 'unfuddled'
require 'unfuddled/client'

require 'unfuddled/error'
require 'unfuddled/error/configuration_error'

require 'unfuddled/api/projects'
require 'unfuddled/api/account'

require 'faraday'
require 'faraday_middleware'
require 'json'

module Unfuddled
  module REST
    class Client < Unfuddled::Client
      include Unfuddled::REST::API::Projects
      include Unfuddled::REST::API::Account

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

      # Perform HTTP PUT Request
      #
      # @param path   [String] Request Path
      # @param params [Hash]   Request Parameters
      def put(path , params = {})
        request(:put , path , params)
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

        response.env
      rescue Faraday::Error::ClientError, JSON::ParserError => error
        raise Unfuddled::Error.new error
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
                          
    end
  end
end
            
