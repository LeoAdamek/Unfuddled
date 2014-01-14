require 'helper'

describe Unfuddled::Error do
  describe '#from_response' do
    it 'takes a hash with a :response_headers as an argument' do
      expect( Unfuddled::Error.from_response({:response_headers => 'TEST'})).to be_an Unfuddled::Error
    end

    it 'takes no arguments' do
      expect( Unfuddled::Error.from_response ).to be_an Unfuddled::Error
    end
  end
end
