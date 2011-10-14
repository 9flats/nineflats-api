require 'fakeweb'
require 'nineflats-api'

Dir["spec/fixtures/*.rb"].each {|f| require File.expand_path(f) }

RSpec.configure do |config|
  # 
end

# make sure no request is sent to the API
FakeWeb.allow_net_connect = false
