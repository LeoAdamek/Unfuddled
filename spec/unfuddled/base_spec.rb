require 'helper'

describe Unfuddled::Base do

  before do
    @base = Unfuddled::Base.new(:id => 1)
  end

  describe '#from_response' do
    before do
      @from_response = Unfuddled::Base.from_response(:body  => {
                                                       :id  => 1,
                                                       :foo => "bar" })
    end
    
    it "should create a Unfuddled::Base from a HTTP Response" do
      expect(@from_response).to be_an Unfuddled::Base
    end

    it "should have a :foo of 'bar'" do
      expect(@from_response.foo).to be_a String
      expect(@from_response.foo).to eq 'bar'
    end

    it "should have an :id of Int(1)" do
      expect(@from_response.id).to be_an Integer
      expect(@from_response.id).to eq 1
    end

  end
      
end
