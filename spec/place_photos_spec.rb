require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Client.connect('client_app_key', 'client_app_secret')
    FakeWeb.register_uri(:get, 
      "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=client_app_key", 
      :body => Fixtures.place
    )
    FakeWeb.register_uri(:get,
      "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/photos?client_id=client_app_key",
      :body => Fixtures.place_photos
    )
  end

  describe "photos" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
    end

    it "should add the photos" do
      @place.photos.length.should == 22
      @place.photos[0].title.should == "Terrace with National Pantheon view"
      @place.photos[0].caption.should == nil
      @place.photos[0].url.should == "http://img2.9flats.com/place_photos/photos/62387-1311446301/large.jpg"
    end

    it "should return an empty array when there are no photos" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/photos?client_id=client_app_key",
        :body => '{"total_entries":0,"place_photos":[]}'
      )

      @place.photos.should == []
    end

    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/photos?client_id=client_app_key",
        :body => '{"error":"Place not found!"}', :status => 404
      )

      expect { @place.photos }.to raise_error(Nineflats::Error, "Place not found!")
    end

    it "should cache the places" do
      Nineflats::Client.should_receive(:place_photos).and_return(JSON.parse(Fixtures.place_photos))
      @place.photos

      Nineflats::Client.should_not_receive(:place_photos)
      @place.photos
    end
  end
end