require 'helper'

describe Unfuddled::REST::Client do
  
  before do
    @client = Unfuddled::REST::Client.new(
                                          :account => 'ACCOUNT',
                                          :username => 'USER',
                                          :password => 'PASS'
                                          )
  end

  describe '.new' do
    context 'when invalid credentials are provided' do
      it 'raises a ConfigurationError exception' do
        expect { 
          Unfuddled::REST::Client.new( :account => ['BROKEN','CONFIG'] )
        }.to raise_exception(Unfuddled::Error::ConfigurationError)

      end
    end

    context 'when no credential are provided' do
      it 'does not raise an error' do
        expect { Unfuddled::REST::Client.new }.not_to raise_error
      end
    end
    
  end

  describe '.credentials?' do
    it 'returns true if all credentials are present' do
      expect(@client.credentials?).to be true
    end

    context 'credentials are missing' do
      it 'returns false if :password is missing' do
        client = Unfuddled::REST::Client.new(:account => 'ACCOUNT' , :username => 'USER')
        expect(client.credentials?).to be false
      end
      
      it 'returns false if :username is missing' do
        client = Unfuddled::REST::Client.new(:account => 'ACCOUNT' , :password => 'PASS')
        expect(client.credentials?).to be false
      end

      it 'returns false if :account is missing' do
        client = Unfuddled::REST::Client.new(:username => 'USER' , :password => 'PASS')
        expect(client.credentials?).to be false
      end
    end
  end
end


