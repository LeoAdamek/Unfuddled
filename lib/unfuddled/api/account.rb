module Unfuddled
  module REST
    module API
      module Account

        # Get the Account information
        #
        # @return [Unfuddled::Account]
        def account
          response = send(:get , '/api/v1/account.json')
          
          Unfuddled::Account.from_response(response)
        end

        # Get the Account details
        # (account-wide lookup values)
        # 
        # @return [Unfuddled::AccountDetails]
        def account_details
          Unfuddled::AccountDetails.from_response(send(:get , '/api/v1/initializer.json'))
        end

      end
    end
  end
end
