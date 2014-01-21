require 'helper'

describe Unfuddled::REST::API::Milestones do
  
  before do
    @client = Unfuddled::REST::Client.new(
                                         :subdomain => "SUBDOMAIN",
                                         :username  => "USERNAME",
                                         :password  => "PASSWORD"
                                         )
  end

  describe '#milestones' do
    before do
      stub_request(:get , stub_path(@client , "/milestones.json"))
        .to_return(:body => "{}",
                   :headers => {
                     :content_type => "application/json"
                   })
                   
    end

    context 'without any arguments' do

      it 'gets all the milestones' do
        @client.milestones
        expect(a_request(:get , stub_path(@client , "/milestones.json"))).to have_been_made
      end

    end

    it 'returns an array of Unfuddled::Milestone' do
      milestones = @client.milestones
      
      expect(milestones).to be_an Array
      
      milestones.each do |m|
        expect(m).to be_an Unfuddled::Milestone
      end
    end

  end

end
