module Unfuddled
  module REST
    module API
      module TimeTracking

        # Get the time invested
        #
        # @return [Unfuddled::TimeInvestedReport]
        def time_invested(options = {})
         response = send(:get , "/api/v1/account/time_invested.json", options)
          
         Unfuddled::TimeInvestedReport.from_response(response)
        end


        # Get a flat list of time entries
        #
        # @return [Array(Unfuddled::TimeEntry)]
        def time_entries(options = {})
          response = send(:get, "/api/v1/account/time_invested.json", options)
          
          entries = response[:body]["groups"].each { |g| g["time_entries"] }.flatten

          process_list_response( entries , Unfuddled::TimeEntry )
        end
        
      end
    end
  end
end
