require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa?client_id=#{Nineflats::Base.client_app_key}&lang=en", 
      :body => place_fixture
    )
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/calendar/2011/10?client_id=#{Nineflats::Base.client_app_key}", 
      :body => place_calendar_fixture
    )
  end
  
  describe "calendar" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
    end

    it "should add the calendar" do
      @place.calendar(2011, 10).year.should == 2011
      @place.calendar(2011, 10).month.should == 10
      @place.calendar(2011, 10).days["1"].should == true
      @place.calendar(2011, 10).days["10"].should == false
      @place.calendar(2011, 10).days["20"].should == false
      @place.calendar(2011, 10).days["30"].should == true
    end

    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/calendar/2011/10?client_id=#{Nineflats::Base.client_app_key}", 
        :body => ''
      )
      
      @place.calendar(2011, 10).should == nil
    end
  end
end