module Unfuddled
  class Project < Unfuddled::Base

    # Get Project Tickets
    #
    # @return [Array(Unfuddled::Ticket)]
    def tickets
      @client.tickets_for_project( id )
    end
     
    # To String
    # @return [String]
    def to_s
      "Unfuddled::Project: #{title}"
    end

  end
end
