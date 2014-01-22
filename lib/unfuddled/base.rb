require 'ostruct'
require 'memoizer'

module Unfuddled
  # Base Class for Unfuddled Objects
  #
  # Inherits from [::OpenStruct] and extends with +#from_response+
  # To allow objects to be created which can make additional requests
  class Base < ::OpenStruct
    attr_accessor :client
    include Memoizer

    # Constructor
    #
    # @param data [Hash] Data to store
    def initialize(data = {})
      super
    end

    class << self

      # Construct object from Response
      # Attaching the client to it for additional requests
      #
      # @param response [Hash]
      # @return [Unfuddled::Base]
      def from_response(response = {} , client = nil)
        if response.keys.include?(:body)
          base = new(response[:body])
        else
          base = new(response)
        end

        base.client = client unless client.nil?
        
        base
      end

    end
    

  end
end
