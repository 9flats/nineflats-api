require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=#{Nineflats::Base.client_app_key}&lang=en", 
      :body => Fixtures.place
    )
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=#{Nineflats::Base.client_app_key}", 
      :body => Fixtures.place_prices
    )
  end
  
  describe "prices" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
    end

    it "should add the basic prices to the place" do
      @place.prices.currency.should == "EUR"
      @place.prices.default_price.should == 90.0
      @place.prices.weekend_night_price.should == 90.0
      @place.prices.weekly_discount_in_percent.should == 5.55
      @place.prices.monthly_discount_in_percent.should == 11.11
    end
    
    it "should add the seasons" do
      @place.prices.seasons.length.should == 2
      @place.prices.seasons[0].from.should == "2011-09-05"
      @place.prices.seasons[0].to.should == "2011-09-30"
      @place.prices.seasons[0].price.should == 100.0
      @place.prices.seasons[0].weekend_night_price.should == 110.0
      @place.prices.seasons[1].from.should == "2011-10-01"
      @place.prices.seasons[1].to.should == "2011-10-31"
      @place.prices.seasons[1].price.should == 75.0
      @place.prices.seasons[1].weekend_night_price.should == 75.0
    end
    
    it "should return an empty seasons array when there are no seasons" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=#{Nineflats::Base.client_app_key}", 
        :body => '{"place_prices":{"currency":"GBP","default_price":64.71,"weekend_night_price":64.71,"weekly_discount_in_percent":null,"monthly_discount_in_percent":null,"seasons":[]}}'
      )
      
      @place.prices.seasons.should == []
    end
    
    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=#{Nineflats::Base.client_app_key}", 
        :body => ''
      )
      
      @place.prices.should == nil
    end
    
    it "should cache the prices" do
      Nineflats::Helpers.should_receive(:get_data).and_return(JSON.parse(Fixtures.place_prices))
      @place.prices

      Nineflats::Helpers.should_not_receive(:get_data)
      @place.prices
    end
  end
end