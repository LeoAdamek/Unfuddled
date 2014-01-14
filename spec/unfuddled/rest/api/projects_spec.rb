require 'helper'

describe Unfuddled::REST::API::Projects do
  
  before do
    @account = "ACCOUNT"
    @username = "USERNAME"
    @password = "PASSWORD"
    @client = Unfuddled::REST::Client.new(
                                          :account => @account,
                                          :username => @username,
                                          :password => @password
                                          )

  end

  describe '#projects' do
    before do
      stub_request( :get , stub_path(@client , "/projects.json"))
        .to_return(:body => fixture("projects.json") , :headers => {
                     :content_type => 'application/json' })
    end

    it 'requests the projects on GET' do
      @client.projects
      expect( a_request(:get , stub_path(@client , '/projects.json') ) ).to have_been_made
    end

    it 'gets the projects' do
      projects = @client.projects
      expect(projects).to be_a Array
      expect(projects.first).to be_a Unfuddled::Project
    end

  end
end


    
                                          
                                          

