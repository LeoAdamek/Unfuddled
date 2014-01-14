require 'helper'

describe Unfuddled::Base do

  before do
    @base = Unfuddled::Base.new(:id => 1)
  end

  describe '#[]' do
    it 'calls methods using [] with symbol' do
      expect(@base[:object_id]).to be_an Integer
    end

    it 'calls methods using [] with string' do
      expect(@base['object_id']).to be_an Integer
    end

    it 'returns nil for a missing method' do
      expect(@base[:not_really_a_method]).to be_nil
      expect(@base['not_really_a_method']).to be_nil
    end

  end

  describe '#attrs' do
    it 'returns a hash of attributes' do
      expect(@base.attrs).to eq(:id => 1)
    end
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
      expect(@from_response.attrs[:foo]).to be_a String
      expect(@from_response.attrs[:foo]).to eq 'bar'
    end

    it "should have an :id of Int(1)" do
      expect(@from_response.attrs[:id]).to be_an Integer
      expect(@from_response.attrs[:id]).to eq 1
    end

  end
end
