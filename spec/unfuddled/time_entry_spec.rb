require 'helper'

describe Unfuddled::TimeEntry do

  before do
    @client = Unfuddled::REST::Client.new(
                                          :subdomain => "SUBDOMAIN",
                                          :username  => "USERNAME",
                                          :password  => "PASSWORD"
                                          )
  end

  describe '#person' do

    before do
      stub_request(:get , stub_path(@client , "/ticket_reports/dynamic.json"))
        .to_return(:body => fixture("tickets.json"),
                   :headers => {
                     :content_type => "application/json"
                   })

      stub_request(:get , stub_path(@client , "/projects/1/tickets/1024/time_entries.json"))
        .to_return(:body => fixture("ticket_time_entries.json"),
                   :headers => {
                     :content_type => "application/json"
                   })

      stub_request(:get , stub_path(@client , "/people/1.json"))
        .to_return(:body => "{}",
                   :headers => {
                     :content_type => "application/json"
                   })
      
      @time_entry = @client.tickets.first.time_entries.first
    end

    it "gets the person's details" do
      @time_entry.person
      expect( a_request(:get , stub_path(@client , "/people/1.json")) ).to have_been_made
    end

    it "returns an Unfuddled::Person" do
      person = @time_entry.person
      expect(person).to be_an Unfuddled::Person
    end
    
  end

end
