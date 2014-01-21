require 'memoizer'

module Unfuddled
  module REST
    module API
      module Account
        
        include ::Memoizer

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
        # @memoized
        # @return [Unfuddled::AccountDetails]
        def account_details
          Unfuddled::AccountDetails.from_response(send(:get , '/api/v1/initializer.json'))
        end
        memoize(:account_details)

      end
    end
  end
end
