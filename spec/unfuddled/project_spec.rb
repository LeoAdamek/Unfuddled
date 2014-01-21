require 'helper'

describe Unfuddled::Project do
  before do
    @client = Unfuddled::REST::Client.new(
                                          :subdomain => "SUBDOMAIN",
                                          :username => "USER",
                                          :password => "PASS"
                                          )

    stub_request(:get , stub_path(@client , '/projects.json'))
      .to_return(:body => fixture("projects.json"),
                 :headers => {
                   :content_type => 'application/json'
                 })

    stub_request(:get , stub_path(@client , "/projects/1024/tickets.json"))
      .to_return(:body => fixture("tickets.json"),
                 :headers => {
                   :content_type => "application/json"
                 })
                

    @project = @client.projects.first
  end

  context 'has attribute accessors which' do
    it 'includes :backup_freqency' do
      expect(@project.backup_frequency).to be_an Integer
      expect(@project.backup_frequency).to be_zero
    end

    it 'includes :ticket_field1_disposition' do
      expect(@project.ticket_field1_disposition).to be_a String
      expect(@project.ticket_field1_disposition).to eq "text"
    end

    it 'includes :ticket_field1_title' do
      expect(@project.ticket_field1_title).to be_a String
      expect(@project.ticket_field1_title).to eq "Field 1"
    end

    it 'includes :ticket_field2_disposition' do
      expect(@project.ticket_field2_disposition).to be_a String
      expect(@project.ticket_field2_disposition).to eq "text"
    end

    it 'includes :ticket_field2_title' do
      expect(@project.ticket_field2_title).to be_a String
      expect(@project.ticket_field2_title).to eq "Field 2"
    end

    it 'includes :ticket_field3_disposition' do
      expect(@project.ticket_field3_disposition).to be_a String
      expect(@project.ticket_field3_disposition).to eq "text"
    end

    it 'includes :ticket_field3_title' do
      expect(@project.ticket_field3_title).to be_a String
      expect(@project.ticket_field3_title).to eq "Field 3"
    end

    it 'includes :tickets which is an array of Unfuddled::Ticket' do
      expect(@project.tickets).to be_an Array
      
      @project.tickets.each do |ticket|
        expect( ticket ).to be_an Unfuddled::Ticket
      end
    end

  end

  describe '#to_s' do
    it 'should be "Unfuddled::Project: :title"' do
      expect(@project.to_s).to be_a String
      expect(@project.to_s).to eq "Unfuddled::Project: Example Project"
    end
  end

  describe '#milestones' do

    context 'without any arguments' do
      before do
        stub_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones.json"))
          .to_return(:body => "{}",
                     :headers => {
                       :content_type => "application/json"
                     })
      end

      it 'gets milestones with the project ID' do
        @project.milestones
        expect( a_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones.json"))).to have_been_made
      end

      it 'returns an array of Unfuddled::Milestone' do
        expect(@project.milestones).to be_an Array

        @project.milestones.each do |milestone|
          expect(milestone).to be_an Unfuddled::Milestone
        end
      end
    end

    context 'when passed :late , :upcoming , :completed or :archived' do
      
      before do
        %w(late upcoming completed archived).each do |status|
          stub_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones/#{status}.json"))
            .to_return(:body => "{}",
                       :headers => {
                         :content_type => "application/json"
                       })
        end
      end

      it 'gets the late milestones when given :late' do
        @project.milestones(:late)
        expect(a_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones/late.json"))).to have_been_made
      end

      it 'gets the upcoming milestones when given :upcoming' do
        @project.milestones(:upcoming)
        expect(a_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones/upcoming.json"))).to have_been_made
      end

      it 'gets the completed milestones when given :completed' do
        @project.milestones(:completed)
        expect(a_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones/completed.json"))).to have_been_made
      end

      it 'gets the archived milestones when given :archived' do
        @project.milestones(:archived)
        expect(a_request(:get , stub_path(@client , "/projects/#{@project.id}/milestones/archived.json"))).to have_been_made
      end

    end

  end

end
