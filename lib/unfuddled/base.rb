require 'addressable/uri'

require 'forwardable'
require 'memoizable'

module Unfuddled
  class Base
    extend Forwardable
    include Memoizable

    attr_reader :attrs
    alias_method :to_h , :attrs
    alias_method :to_hash , :attrs
    alias_method :to_hsh , :attrs


    # Constructor
    #
    # @param attrs [Hash]
    # @return [Unfuddled::Base]
    def initialize(attrs = {})
      @attrs = attrs || {}
    end

    # Fetches and attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send the object
    def [](method)
      send(method.to_sym)
    rescue NoMethodError
      nil
    end

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
    
