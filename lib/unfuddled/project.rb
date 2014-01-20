module Unfuddled
  class Project < Unfuddled::Base

    def tickets
      @client.tickets_for_project( id )
    end
      

  end
end
