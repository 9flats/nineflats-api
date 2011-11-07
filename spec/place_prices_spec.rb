require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Client.connect('client_app_key', 'client_app_secret')
    FakeWeb.register_uri(:get, 
      "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=client_app_key", 
      :body => Fixtures.place
    )
  end

  describe "prices" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=client_app_key",
        :body => Fixtures.place_prices
      )
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
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=client_app_key",
        :body => '{"place_prices":{"currency":"GBP","default_price":64.71,"weekend_night_price":64.71,"weekly_discount_in_percent":null,"monthly_discount_in_percent":null,"seasons":[]}}'
      )

      @place.prices.seasons.should == []
    end

    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=client_app_key",
        :body => '{"error":"Place not found!"}', :status => 404
      )

      expect { @place.prices }.to raise_error(Nineflats::Error, "Place not found!")
    end

    it "should cache the prices" do
      Nineflats::Client.should_receive(:place_prices).and_return(JSON.parse(Fixtures.place_prices))
      @place.prices

      Nineflats::Client.should_not_receive(:place_prices)
      @place.prices
    end
  end
end
