require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("client_app_key")
    FakeWeb.register_uri(:get,
      "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=client_app_key&lang=en",
      :body => Fixtures.place
    )
  end

  describe "fetch" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
    end

    it "should return a place" do
      @place.class.should == Nineflats::Place
    end

    it "should set all the attributes" do
      @place.name.should == "Great river view, Colorful and Cozy"
      @place.city.should == "Lisboa"
      @place.slug.should == "apt-no-centro-histrico-de-lisboa"
      @place.zipcode.should == "1100-188"
      @place.number_of_beds.should == 4
      @place.number_of_bedrooms.should == 1
      @place.currency.should == "EUR"
      @place.lat.should == 38.7173993
      @place.lng.should == -9.1204621
      @place.district.should == ""
      @place.number_of_bathrooms.should == 1
      @place.charge_per_extra_person.should == 20.0
      @place.minimum_nights.should == 2
      @place.maximum_nights.should == 365
      @place.bed_type.should == "Real bed"
      @place.content_language == "en"
      @place.size.should == 70.0
      @place.house_rules.should == ""
      @place.pets_around.should == false
      @place.bathroom_type.should == "Private"
      @place.cleaning_fee.should == nil
      @place.charge_per_extra_person_limit.should == 4
      @place.favorites_count.should == 5
      @place.amenities_list.should == ["Internet", "Wifi (Wireless LAN)", "TV", "Air Conditioning", "Kitchen", "Washer", "Smoking allowed", "Family/Kid friendly", "Pets allowed", "Balcony", "Dishwasher", "Fridge/freezer", "Shower/bathtub", "Baby crib", "Final cleaning", "Panoramic view", "Gay friendly"]
      @place.featured_photo_url.should == "http://img1.9flats.com/place_photos/photos/62387-1311446301/medium.jpg"
      @place.price.should == 90.0
      @place.country.should == "Portugal"
      @place.category.should == "Apartment"
      @place.place_type.should == "Entire place"
      @place.description.should == "Panoramic terrace in the historic center of Lisbon, close to Subway and Airport"
    end

    it "should set the links" do
      @place.links['self'].should == "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=client_app_key"
      @place.links['full'].should == "http://www.9flats.com/places/apt-no-centro-histrico-de-lisboa"
      @place.links['photos'].should == "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/photos?client_id=client_app_key"
      @place.links['prices'].should == "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/prices?client_id=client_app_key"
      @place.links['reviews'].should == "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=client_app_key"
      @place.links['calendar: current month'].should == "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/calendar/2011/10?client_id=client_app_key"
      @place.links['calendar: next month'].should == "http://api.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/calendar/2011/11?client_id=client_app_key"
    end

    it "should set the host" do
      @place.host.class.should == Nineflats::User
      @place.host.name.should == "Paulo M."
      @place.host.slug.should == "paulo-m"
    end
  end
end