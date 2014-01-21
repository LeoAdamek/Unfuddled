module Unfuddled
  class Ticket < Unfuddled::Base
    
    # Get the time entries for the ticket
    #
    # @return [Array[Unfuddled::TimeEntry]]
    def time_entries
      url = "/api/v1/projects/#{project_id}/tickets/#{id}/time_entries.json"
     
      @client.process_list_response( @client.send(:get , url)[:body] , Unfuddled::TimeEntry )
    end

    # Get the project for the ticket
    #
    # @return [Unfuddled::Project]
    def project
      @client.project(:id => project_id)
    end

  end
end
