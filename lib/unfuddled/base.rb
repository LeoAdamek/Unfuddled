require 'ostruct'

module Unfuddled
  class Base < ::OpenStruct

    def perform_with_object(klass , request_method , path , options = {} )
      klass.from_response( send(request_method.to_sym , path , options) )
    end

    class << self

      # Construct object from Response
      #
      # @param response [Hash]
      # @return [Unfuddled::Base]
      def from_response(response = {} , client = nil)
        @client = client unless client.nil?
        
        if response.keys.include?(:body)
          new(response[:body])
        else
          new(response)
        end
      end

    end
    

  end
end
    
