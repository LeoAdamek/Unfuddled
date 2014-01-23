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

        def ticket(filters = {})
          raise Unfuddled::Error.new("Cannot get a single ticket without an ID") unless filters.has_key?(:id)

          if filters.has_key?(:project_id) then
            url = "/api/v1/projects/#{filters[:project_id]}/tickets/#{filters[:id]}.json"
            ticket = Unfuddled::Ticket.from_response(send(:get, url)[:body] ,  self)
          else
            ticket = tickets.select { |t| t.id == filters[:id] }.first
          end

          ticket
        end
        memoize(:ticket)

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
          if ticket.priority.nil? or ticket.project_id.nil? or ticket.summary.nil?
            raise Unfuddled::Error.new("Must have Priority (1..5), Project ID and Summary")
          end

          begin
            url = "/api/v1/projects/#{ticket.project_id}/tickets.json"
            id  = send(:post , url, ticket.to_h)[:body][:id]
            
            # Add the ID with to ticket
            ticket.id = id

            # Attach the client to the ticket
            ticket.client = self
            
            ticket
          rescue Unfuddled::HTTPErrorResponse => error
            raise error
          end

        end

      end
    end
  end
end
