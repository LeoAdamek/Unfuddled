module Unfuddled
  module REST
    module API
      module People

        # Get a person by id
        #
        # @param id [Integer] Person ID
        # @return Unfuddled::Person
        def person(id)
          Unfuddled::Person.from_response( send(:get , "/api/v1/people/#{id}.json")[:body] , self )
        end

      end
    end
  end
end
