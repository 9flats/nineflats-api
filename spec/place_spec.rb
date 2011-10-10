require 'spec_helper'
require 'nineflats-api'

describe Nineflats::Place do
  describe "fetch" do
    it "should description" do
      puts Nineflats::Place.fetch('cowoco', 'en')
    end
  end
end