require 'helper'

describe Unfuddled::REST::API::Projects do
  
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

  describe '#projects' do
    before do
      stub_request( :get , stub_path(@client , "/projects.json"))
        .to_return(:body => fixture("projects.json") , :headers => {
                     :content_type => 'application/json' })
    end

    context 'without any arguments' do
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
  
  describe '#project' do

    context 'with arguments' do
      before do
        stub_request(:get , stub_path(@client , "/projects/by_short_name/valid_project.json"))
          .to_return(:body => fixture("project.json"),
                     :headers => {
                       :content_type => "application/json"
                     })
      end

      it 'gets an existing project by :name' do
        @client.project(:name => "valid_project")
        expect( a_request(:get , stub_path(@client , "/projects/by_short_name/valid_project.json"))).to have_been_made
      end

      it 'returns a single Unfuddled::Project' do
        project = @client.project(:name => "valid_project")
        expect(project).to be_an Unfuddled::Project
      end

    end
    
  end
end


    
                                          
                                          

