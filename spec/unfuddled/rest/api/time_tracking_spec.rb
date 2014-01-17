require 'helper'

describe Unfuddled::REST::API::TimeTracking do
  
  before do
    @subdomain = "SUBDOMAIN"
    @username = "USERNAME"
    @password = "PASSWORD"

    @client = Unfuddled::REST::Client.new(
                                          :subdomain => @subdomain,
                                          :username  => @username,
                                          :password  => @password
                                          )

  end

  describe '#time_invested' do
    context 'without any arguments' do
      before do
        stub_request( :get , stub_path(@client , "/account/time_invested.json"))
          .to_return(:body => fixture("time_invested.json"),
                     :headers => {
                       :content_type => "application/json"
                     })
      end
      
      it 'GETs the global time invested report' do
        @client.time_invested
        expect(a_request(:get , stub_path(@client , "/account/time_invested.json"))).to have_been_made
      end

      it 'returns an Unfuddled::TimeInvestedReport' do
        time_entries = @client.time_invested
        expect(time_entries).to be_an Unfuddled::TimeInvestedReport
      end
      
    end
  end
end
