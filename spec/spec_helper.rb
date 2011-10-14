require 'fakeweb'
require 'nineflats-api'
require 'fixtures'

RSpec.configure do |config|
  # 
end

# make sure no request is sent to the API
FakeWeb.allow_net_connect = false
