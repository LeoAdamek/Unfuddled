module Unfuddled
  class Error < StandardError

    class << self
      # Create an Error from an Erroneous HTTP Response
      #
      # @param response[Hash]
      # @return [Unfuddled::Error]
      def from_response(response = {})
        new(response[:response_headers])
      end
    end
  end
end
      
