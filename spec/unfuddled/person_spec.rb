require 'helper'

describe Unfuddled::Person do

  before do

    @client = Unfuddled::REST::Client.new(
                                          :subdomain => "SUBDOMAIN",
                                          :username  => "USERNAME",
                                          :password  => "PASSWORD"
                                          )

    stub_request(:get , stub_path(@client , "/people/1.json"))
      .to_return(:body => fixture("person.json"),
                 :headers => {
                   :content_type => "application/json"
                 })

    @person = @client.person(1)
  end

  describe '#to_s' do
    it 'returns "Unfuddled::Person: :first_name :last_name"' do
      expect(@person.to_s).to be_a String
      expect(@person.to_s).to eq "Unfuddled::Person: John Smith"
    end
  end

end
