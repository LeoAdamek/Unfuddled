require 'memoizer'

module Unfuddled
  module REST
    module API
      module People
        
        include ::Memoizer

        # Get a person by id
        #
        # @memoized
        #
        # @param id [Integer] Person ID
        # @return Unfuddled::Person
        def person(id)
          Unfuddled::Person.from_response( send(:get , "/api/v1/people/#{id}.json")[:body] , self )
        end
        memoize(:person)

      end
    end
  end
end
