
#
# Coverage Reports (reporting to coveralls
#
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
end

#
# RSpec + WebMock Configuration
#
require 'unfuddled'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def stub_path(client , path)
  c = client.credentials
  "https://#{c[:username]}:#{c[:password]}@#{c[:account]}.unfuddle.com/api/v1" + path
end
  

# Fixtures configuration
def fixture_path
  File.expand_path( '../fixtures' , __FILE__ )
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
