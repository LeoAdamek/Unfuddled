require 'helper'

describe Unfuddled::Client do
  
  describe '#initialize' do
    it 'should take a hash for an argument' do
      expect(Unfuddled::Client.new( {:account => 'test'} ) ).to be_an Unfuddled::Client
    end

    it 'should take no arguments' do
      expect(Unfuddled::Client.new).to be_an Unfuddled::Client
    end
  end

  describe '#user_agent' do
    before do
      @client = Unfuddled::Client.new
    end

    it 'should be set to "Unfuddle Ruby Gem Client"' do
      expect(@client.user_agent).to be_a String
      expect(@client.user_agent).to eq 'Unfuddled Ruby Gem Client'
    end
  end

end
             
