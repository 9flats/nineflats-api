require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Client.connect('client_app_key', 'client_app_secret')
    FakeWeb.register_uri(:get, 
      "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=client_app_key", 
      :body => Fixtures.place
    )
  end

  describe "calendar" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
    end

    it "should add the calendar" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/calendar/2011/10?client_id=client_app_key",
        :body => Fixtures.place_calendar
      )

      @place.calendar(2011, 10).year.should == 2011
      @place.calendar(2011, 10).month.should == 10
      @place.calendar(2011, 10).days["1"].should == true
      @place.calendar(2011, 10).days["10"].should == false
      @place.calendar(2011, 10).days["20"].should == false
      @place.calendar(2011, 10).days["30"].should == true
    end

    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/calendar/2011/10?client_id=client_app_key",
        :body => '{"error":"You cannot access calendars in the past!"}', :status => 422
      )

      expect { @place.calendar(2011, 10) }.to raise_error(Nineflats::Error, "You cannot access calendars in the past!")
    end
  end
end