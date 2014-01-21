require 'ostruct'

module Unfuddled
  class Base < ::OpenStruct
    attr_accessor :client

    class << self

      # Construct object from Response
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
    
