require 'ostruct'

module Unfuddled
  class Base < ::OpenStruct
    attr_accessor :client

    def perform_with_object(klass , request_method , path , options = {} )
      klass.from_response( send(request_method.to_sym , path , options) )
    end

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
    
