require 'rubygems'
require 'bundler/setup'
require 'fakeweb'
require 'nineflats-api'

Dir["spec/fixtures/*.rb"].each {|f| require File.expand_path(f) }

RSpec.configure do |config|
  # 
end
