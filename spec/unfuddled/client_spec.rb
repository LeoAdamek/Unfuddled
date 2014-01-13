require 'helper'

describe Unfuddled::Client do
  
  describe '#initialize' do
    it 'should take a hash for an argument' do
      expect(Unfuddle::Client.new({:foo => 'bar'})).to be_a subject
    end

    it 'should take no arguments' do
      expect(Unfuddle::Client.new).to be_a subject
    end
  end

  describe '#user_agent' do
    before do
      client = Unfuddle::Client.new
    end

    it 'should be set to "Unfuddle Ruby Gem Client"' do
      expect(client.user_agent).to be_a String
      expect(client.user_agent).to eq 'Unfuddle Ruby Gem Client'
    end
  end

end
             
