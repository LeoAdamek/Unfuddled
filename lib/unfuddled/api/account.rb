module Unfuddled
  module REST
    module API
      module Account

        # Get the Account details
        #
        # @return [Unfuddled::Account]
        def account
          response = send(:get , '/api/v1/account.json')
          
          Unfuddled::Account.from_response(response)
        end
      end
    end
  end
end
