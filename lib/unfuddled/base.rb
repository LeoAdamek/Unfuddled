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

      # Define methods retrieve the value from attributes
      #
      # @param attrs [Array, Symbol]
      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      # Define object methods from attributes
      # 
      # @param klass [Symbol]
      # @param key_one [Symbol]
      # @param key_two [Symbol]
      def object_attr_reader(klass, key_one, key_two = nil)
        define_attribute_method(key_one, klass, key_two)
        define_predicate_method(key_one)
      end

      private

      # Dynamically define a method for a URI
      #
      # @param key_one [Symbol]
      # @param key_two [Symbol]
      def define_uri_method(key_one, key_two)
        define_method(key_one) do
          Addressable::URI.parse(@attrs[key_two]) unless @attrs[key_two].nil?
        end

        memoize key_one
      end

      private
      
      # Dynamically define a method for an attribute
      #
      # @param key_one [Symbol]
      # @param klass   [Symbol]
      # @param key_two [Symbol]
      def define_attribute_method(key_one , klass = nil , key_two = nil)
        define_method(key_one) do ||
            if klass.nil?
              @attrs[key_one]
            else
              if @attrs[key_0one].nil?
                NullObject.new
              else
                attrs = attrs_for_object(key_one, key_two)
                Unfuddled.const_get(klass).new(attrs)
              end
            end
        end
        
        memoize key_one 
      end
      
      
            
    end
  end
end
    
