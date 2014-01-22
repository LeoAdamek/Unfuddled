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


        # Create a new Ticket
        #
        # @return [Unfuddled::Ticket]
        # @param ticket [Unfuddled::Ticket] Ticket to create
        def create_ticket(ticket)
          raise Unfuddled::Error.new("Ticket must have a Project ID") if ticket.project_id.nil?
          raise Unfuddled::Error.new("Ticket must have a summary") if ticket.summary.nil?
          raise Unfuddled::Error.new("Ticket must have a priority between 1 and 5") unless ticket.priority.is_a?(Integer) and ticket.priority.between?(1,5)

          begin
            url = "/api/v1/projects/#{ticket.project_id}/tickets.json"
            id  = send(:post , url, ticket.to_h)[:body][:id]
            
            # Add the ID with to ticket
            ticket.id = id

            # Attach the client to the ticket
            ticket.client = self
            
            ticket
          rescue Unfuddled::HTTPErrorResponse => error
            error
          end

        end

      end
    end
  end
end
