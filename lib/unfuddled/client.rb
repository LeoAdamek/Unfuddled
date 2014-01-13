module Unfuddled
  class Client

    # Accessible attributes
    attr_accessor :account , :username , :password

    # Constructor
    #
    # @param options [Hash]
    # @return [Unfuddled::Client]
    def initialize(options = {})
      options.each do |key , value|
        send(:"#{key}=" , value)
      end

      yield self if block_given?
      validate_credential_type!
    end

    # Get the User Agent
    #
    # @return [String]
    def user_agent
      @user_agent ||= "Unfuddled Ruby Gem Client"
    end

    # Check the Credentials
    #
    # @return [Boolean]
    def credentials?
      credentials.values.all?
    end

    private
    # Ensure all credentials set curing confiration
    # Are of a valid type [String, Symbol]
    def validate_credential_type!
      credentials.each do |credential, value|
        next if value.nil?
        fail(Error::ConfigurationError,
             "Invalid #{credential}, type given was #{value.inspect}, must be String or Symbol."
        ) unless value.is_a?(String) || value.is_a?(Symbol)
      end
    end
        
    
  end
end
