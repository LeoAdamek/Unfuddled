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

  context 'when the response is unsuccessful or invalid' do
    before do
      stub_request(:get , stub_path(@client , '/not_found'))
        .to_return(:status => 404)

      stub_request(:get , stub_path(@client , "/invalid"))
        .to_return(:body => "Invalid Response" ,
                   :headers => {
                     :content_type => "application/json"
                   })

    end

    it 'throws an Unfuddled::Error when the response is not vaid JSON' do
      expect { @client.get("/api/v1/invalid") }.to raise_error(Unfuddled::Error)
    end
  
  end

  context 'when the requested resource is not found (404)' do
    before do
      stub_request(:get , stub_path(@client , '/not_found'))
        .to_return(:status => 404)
    end

    it 'raises an Unfuddled::NotFound error' do
      expect { @client.get("/api/v1/not_found") }.to raise_error(Unfuddled::NotFoundError)
    end
  end

  context 'when the user it not allowed to view the resource (403)' do
    before do
      stub_request(:get , stub_path(@client , '/not_allowed'))
        .to_return(:status => 403)
    end

    it 'raises an Unfuddled::AccessDeniedError' do
      expect { @client.get("/api/v1/not_allowed") }.to raise_error(Unfuddled::AccessDeniedError)
    end
  end



end


