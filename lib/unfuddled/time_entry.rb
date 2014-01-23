module Unfuddled
  class TimeEntry < Unfuddled::Base

    # Get the Person who logged this time
    #
    # @return [Unfuddled::Person]
    def person
      @client.person(id)
    end

    # Get the Ticket thsi timee was logged to
    # 
    # @return [Unfuddled::Ticket]
    def ticket
      @client.ticket(:id => ticket_id)
    end

  end
end
