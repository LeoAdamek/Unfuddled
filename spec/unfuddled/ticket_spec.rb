require 'unfuddled'

describe Unfuddled::Ticket do

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

  describe '#time_entries' do

    before do
      stub_request(:get , stub_path(@client , '/ticket_reports/dynamic.json'))
        .to_return(:body => fixture("tickets.json"),
                   :headers => {
                     :content_type => "application/json"
                   })

      @ticket = @client.tickets.first

      stub_request( :get , stub_path(@client , '/projects/1/tickets/1024/time_entries.json'))
        .to_return(:body => fixture("ticket_time_entries.json"),
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    it 'gets the time entries' do
      @ticket.time_entries
      expect( a_request( :get , stub_path(@client , '/projects/1/tickets/1024/time_entries.json')) ).to have_been_made
    end

    it 'returns an array of Unfuddled::TimeEntry' do
      time_entries = @ticket.time_entries
      
      expect(time_entries).to be_an Array
      
      time_entries.each do |entry|
        expect(entry).to be_an Unfuddled::TimeEntry
      end
    end
    
  end

end
