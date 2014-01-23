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

  describe '#ticket' do
    context 'without any arguments' do
      it 'raises an Unfuddled::Error' do
        expect { @client.ticket }.to raise_error( Unfuddled::Error )
      end
    end
    
    context 'with a :project_id and :id' do
      before do
        stub_request(:get , stub_path(@client , "/projects/1/tickets/1024.json"))
          .to_return(:body => "{}",
                     :headers => {
                       :content_type => "application/json"
                     })
      end
      
      it 'gets the ticket directly' do
        @client.ticket( :project_id => 1 , :id => 1024 )
        expect( a_request(:get , stub_path(@client , "/projects/1/tickets/1024.json"))).to have_been_made
      end
    end

  end


  describe '#create_ticket' do
    before do
      @ticket = Unfuddled::Ticket.new(
        :project_id => 1,
        :milestone_id => 2,
        :summary => "My New Ticket",
                                      :priority => 3
      )

      stub_request(:post , stub_path(@client , "/projects/#{@ticket.project_id}/tickets.json"))
        .with(:body => @ticket.to_h)
        .to_return(:status => 201,
                   :body   => "{\"id\" : 1440}",
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    it 'POSTs the Ticket' do
      @client.create_ticket(@ticket)
      expect(a_request(:post , stub_path(@client , "/projects/#{@ticket.project_id}/tickets.json"))).to have_been_made
    end

    it 'returns an Unfuddled::Ticket' do
      expect(@client.create_ticket(@ticket)).to be_an Unfuddled::Ticket
    end

    it 'returns an Unfuddled::Ticket with a client' do
      ticket = @client.create_ticket(@ticket)
      expect(ticket.client).to be_an Unfuddled::Client
    end

  end

end
