require 'helper'

describe Unfuddled::REST::API::Tickets do

  before do
    @subdomain = :SUBDOMAIN
    @username  = :USERNAME
    @password  = :PASSWORD
    @client = Unfuddled::REST::Client.new(
                                         :subdomain => @subdomain,
                                         :username  => @username,
                                         :password  => @password
                                         )


  end

  describe '#tickets' do

    context 'without any arguments' do
      before do
        stub_request(:get , stub_path(@client , '/ticket_reports/dynamic.json'))
          .to_return(:body => fixture("tickets.json"),
                     :headers => {
                       :content_type => "application/json"
                     })
      end
      
      it 'gets all the tickets' do
        @client.tickets
        expect( a_request(:get , stub_path(@client , "/ticket_reports/dynamic.json")) ).to have_been_made
      end

      it 'returns an array of Unfuddled::Ticket' do
        tickets = @client.tickets
        expect(tickets).to be_an Array

        tickets.each do |t|
          expect(t).to be_an Unfuddled::Ticket
        end
      end


    end

  end

end
