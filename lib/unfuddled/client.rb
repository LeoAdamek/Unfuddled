module Unfuddled
  class Client

    # Constructor
    #
    # @param options [Hash]
    # @return [Unfuddled::Client]
    def initialize(options = {})
      options.each do |key , value|
        send(:"#{key}=" , value)
      end

      yield self if block_given?
    end

    # Get the User Agent
    #
    # @return [String]
    def user_agent
      @user_agent ||= "Unfuddled Ruby Gem Client"
    end
    
  end
end
