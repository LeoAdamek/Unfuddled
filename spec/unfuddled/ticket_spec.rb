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

    stub_request(:get , stub_path(@client , '/ticket_reports/dynamic.json'))
      .to_return(:body => fixture("tickets.json"),
                 :headers => {
                   :content_type => "application/json"
                 })

    @ticket = @client.tickets.first

  end

  describe '#time_entries' do

    before do
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

  describe '#project' do
    before do
      stub_request(:get , stub_path(@client , "/projects/1.json"))
        .to_return(:body => fixture("project.json"),
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    it 'gets the project' do
      @ticket.project
      
      expect( a_request(:get , stub_path(@client , "/projects/1.json"))).to have_been_made
    end

    it 'returns an Unfuddled::Project' do
      expect(@ticket.project).to be_an Unfuddled::Project
    end
  end


  describe '#to_s' do
    it 'should be "Unfuddled::Ticket: #:number :summary"' do
      expect(@ticket.to_s).to be_a String
      expect(@ticket.to_s).to eq "Unfuddled::Ticket: #404 Example Ticket"
    end
  end

  describe '#custom_fields' do

    before do

      stub_request(:get , stub_path(@client , "/projects/1.json"))
        .to_return(:body => fixture("project.json"),
                   :headers => {
                     :content_type => "application/json"
                   })

    end

    it 'should return an Array of Unfuddled::CustomField s' do
      expect(@ticket.custom_fields).to be_an Array

      @ticket.custom_fields.each do |field|
        expect(field).to be_an Unfuddled::CustomField
      end
    end
  end

  describe '#reporter' do

    before do

      stub_request( :get , stub_path(@client , "/people/1.json") )
        .to_return(:body => fixture("person.json"),
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    it 'gets the reporter' do
      @ticket.reporter
      expect( a_request(:get , stub_path( @client , "/people/1.json")) ).to have_been_made
    end

    it 'returns an Unfuddled::Person' do
      expect(@ticket.reporter).to be_an Unfuddled::Person
    end
  end

  describe '#milestone' do
    before do

      stub_request(:get , stub_path(@client , "/projects/1/milestones/2.json"))
        .to_return(:body => "{}",
                   :headers => {
                     :content_type => "application/json"
                   })
    end

    it 'gets the milestone' do
      @ticket.milestone
      expect(a_request(:get, stub_path(@client, "/projects/1/milestones/2.json"))).to have_been_made
    end

    it 'returns an Unfuddled::Milestone' do
      expect(@ticket.milestone).to be_an Unfuddled::Milestone
    end
  end

  describe '#save' do
    context 'when the ticket is new' do
      before do
        @ticket_data = {
          :project_id => 1,
          :milestone_id => 2,
          :summary => "New Ticket",
          :description => "New Ticket Description",
          :description_format => "markdown"
        }

        stub_request(:post , stub_path(@client , "/projects/#{@ticket_data[:project_id]}/tickets.json"))
          .with(:body => @ticket_data)
          .to_return(:body => '{"status" : "success"}',
                     :headers => {
                       :content_type => 'application/json'
                     })
      end

      pending 'POSTs the Ticket' do
        ticket = Unfuddled::Ticket.new(@ticket_data)
        ticket.save
        expect(a_request(:post , stub_path(@client , "/projects/#{@ticket_data[:project_id]}/tickets.json"))).to have_been_made
      end

    end

    context 'when the ticket already exists' do
      before do

        stub_request(:put , stub_path(@client, "/projects/#{@ticket.project_id}/tickets/#{@ticket.id}.json"))
          .with(:body => @ticket.to_h)
          .to_return(:body => '{"success" : true}',
                     :headers => {
                       :content_type => "application/html"
                     })
      end

      it 'PUTs the Ticket' do
        @ticket.save
        expect(a_request(:put , stub_path(@client , "/projects/#{@ticket.project_id}/tickets/#{@ticket.id}.json"))).to have_been_made
      end
    end

  end
end
