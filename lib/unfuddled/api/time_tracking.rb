module Unfuddled
  module REST
    module API
      module TimeTracking

        # Get the time invested
        #
        #
        def time_invested(options = {})
         response = send(:get , "/api/v1/account/time_invested.json", options)
          
         Unfuddled::TimeInvestedReport.from_response(response)
        end
        
      end
    end
  end
end
