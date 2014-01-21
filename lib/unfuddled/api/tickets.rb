require 'memoizer'

module Unfuddled
  module REST
    module API
      module Tickets

        include ::Memoizer

        # Gets tickets
        #
        # Filters can be supplied as :key => value pairs
        def tickets(filters = {})
          tickets = send(:get , '/api/v1/ticket_reports/dynamic.json', filters)

          tickets = tickets[:body]["groups"].first["tickets"]

          process_list_response( tickets , Unfuddled::Ticket)
        end
        memoize(:tickets)

        # Gets tickets for a project
        def tickets_for_project(project_id)
          tickets = send(:get , "/api/v1/projects/#{project_id}/tickets.json")

          process_list_response( tickets , Unfuddled::Ticket )
        end
        
      end
    end
  end
end
