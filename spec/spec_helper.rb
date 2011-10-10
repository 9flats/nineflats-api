require 'rubygems'
require 'bundler/setup'

require 'nineflats-api'

RSpec.configure do |config|
  config.fixture_path = '/spec/fixtures/'
end

FakeWeb.register_uri(:get, "http://api.9flats.com/place/cowoco/", :body => "")