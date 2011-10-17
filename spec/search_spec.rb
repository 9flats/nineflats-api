require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
  end
  
  describe "search" do
    it "should build the search query from the parameters" do
      Nineflats::Helpers.should_receive(:get_data).with(
        "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[query]=Siena&search[number_of_beds]=3&search[currency]=USD"
      ).and_return(JSON.parse(Fixtures.search_result))
      Nineflats::Place.search({:query => "Siena", :number_of_beds => 3, :currency => "USD"})
    end
  end
  
  context "correct query" do
    before(:each) do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[query]=Siena&search[number_of_beds]=3&search[currency]=USD", 
        :body => Fixtures.search_result
      )
      @result = Nineflats::Place.search({:query => "Siena", :number_of_beds => 3, :currency => "USD"})
    end
    
    it "should return an array of places" do
      @result.length.should == 9
      @result.first.class.should == Nineflats::Place
      @result.first.city.should == "Siena"
      @result.first.slug.should == "splendida-villa-toscana-"
    end
  end
end