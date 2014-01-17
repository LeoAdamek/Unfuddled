require 'helper'

describe Unfuddled::REST::API::Account do
  
  before do
    @subdomain = "SUBDOMAIN"
    @username = "USERNAME"
    @password = "PASSWORD"
    @client = Unfuddled::REST::Client.new(
                                          :subdomain => @subdomain,
                                          :username => @username,
                                          :password => @password
                                          )

  end

  describe '#account' do
    before do
      stub_request(:get , stub_path(@client , '/account.json'))
        .to_return(:body => fixture("account.json"),
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    context 'without any arguments' do
      it 'requests the account via GET' do
        @client.account
        expect( a_request(:get , stub_path(@client , '/account.json')) ).to have_been_made
      end

      it 'gets the account details' do
        account = @client.account
        expect(account).to be_an Unfuddled::Account
      end
    end
  end

  describe '#account_details' do
    before do
      stub_request(:get , stub_path(@client , '/initializer.json'))
        .to_return(:body => fixture("account_details.json"),
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    it 'GETs the account details' do
      @client.account_details
      expect(a_request(:get , stub_path(@client , '/initializer.json'))).to have_been_made
    end
    
    it 'returns an Unfuddled::AccountDetails' do
      expect(@client.account_details).to be_an Unfuddled::AccountDetails
    end

  end
    
      

end
