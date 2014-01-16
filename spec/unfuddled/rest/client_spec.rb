require 'helper'

describe Unfuddled::REST::Client do
  
  before do
    @subdomain = "subdomain"
    @username = "USERNAME"
    @password = "PASSWORD"
    @client = Unfuddled::REST::Client.new(
                                          :subdomain => @subdomain,
                                          :username => @username,
                                          :password => @password
                                          )
  end

  describe '.middleware' do
    it 'returns a Faraday::Builder' do
      expect(@client.middleware).to be_a ::Faraday::Builder
    end
  end

  describe '.connection_options' do
    it 'returns a hash' do
      expect(@client.connection_options).to be_a Hash
    end
  end
  
  describe '.endpoint' do
    it 'returns https://{{subdomain}}.unfuddle.com/api/v1' do
      expect(@client.endpoint).to be_a String
      expect(@client.endpoint).to eq("https://#{@subdomain}.unfuddle.com/api/v1")
    end
  end

  describe '.new' do
    context 'when invalid credentials are provided' do
      it 'raises a ConfigurationError exception' do
        expect { 
          Unfuddled::REST::Client.new( :subdomain => ['BROKEN','CONFIG'] )
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
        client = Unfuddled::REST::Client.new(:subdomain => 'SUBDOMAIN' , :username => 'USER')
        expect(client.credentials?).to be false
      end
      
      it 'returns false if :username is missing' do
        client = Unfuddled::REST::Client.new(:subdomain => 'SUBDOMAIN' , :password => 'PASS')
        expect(client.credentials?).to be false
      end

      it 'returns false if :subdomain is missing' do
        client = Unfuddled::REST::Client.new(:username => 'USER' , :password => 'PASS')
        expect(client.credentials?).to be false
      end
    end
  end

  it 'does not persist credentials between clients' do
    @client_a = Unfuddled::REST::Client.new(
                                            :subdomain => "subdomain",
                                            :username => "USERA",
                                            :password => "PASSWORDA"
                                            )

    @client_b = Unfuddled::REST::Client.new(
                                            :subdomain => "subdomain",
                                            :username => "USERB",
                                            :password => "PASSWORDB"
                                            )

    expect(@client_a).not_to eq(@client_b)
  end

=begin
  context 'when the response is invalid' do
    before do
      stub_request(:get , stub_path(@client , "/error/get"))
        .to_return(:body => fixture("invalid.json"),
                   :headers => { :content_type => "application/json"})
    end
    
    it 'should raise an Unfuddled::Error' do
      expect(@client.get("/api/v1/error/get")).to raise_exception(Unfuddled::Error)
    end
  end
=end



=begin  
# Tests for HTTP requests have ben removed because they don't work, incorrectly.
  describe '#put' do

    before do
     stub_request( :put , stub_path(@client , "/custom/put")).with(:body => {:updated => "object"})
    end

    it 'allows custom put requests' do
      @client.put('/api/v1/custom/put' , :updated => 'object')
      expect( 
             a_request(:get  , stub_path(@client , '/custom/put'))
               .with(:body => {:updated => 'object'}) 
             ).to have_been_made
    end

  end

  describe '#get' do
    
    before do
      stub_request( :get , stub_path(@client , '/custom/get?requested=body'))
    end

    it 'allows custom get requests' do
      @client.get('/api/v1/custom/get', :requested => 'object')
      expect(
             a_request(:get , stub_path(@client , '/custom/get?requested=object') )
               .with(:body => {:requested => "object" })
             ).to have_been_made
    end
  end
=end  
  describe '#post' do
    before do
      stub_request( :post ,
                    stub_path(@client , '/custom/post'))
        .with(:body => { :created => "object" } )
    end

    it 'allows custom POST requests' do
      @client.post('/api/v1/custom/post' , :created => "object")
      expect(
             a_request(:post , stub_path(@client , '/custom/post'))
               .with(:body => {:created => "object"})
             ).to have_been_made
    end
  end

end


