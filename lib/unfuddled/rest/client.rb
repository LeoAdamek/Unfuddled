require 'unfuddled'
require 'unfuddled/client'

require 'unfuddled/error'
require 'unfuddled/error/configuration_error'

module Unfuddled
  module REST
    class Client < Unfuddled::Client
      
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
        @middleware ||= Faraday::Builder.new do |builder|
          
          # Use the Faraday HTTP adapter
          builder.adapter Faraday.default_adapter
        end
      end
      
    end
  end
end
            
