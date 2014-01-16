require 'ostruct'

module Unfuddled
  class Base < ::OpenStruct

    class << self

      # Construct object from Response
      #
      # @param response [Hash]
      # @return [Unfuddled::Base]
      def from_response(response = {})
        new(response[:body])
      end
    end

  end
end
    
