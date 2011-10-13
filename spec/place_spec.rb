require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa.json?client_id=#{Nineflats::Base.client_app_key}&lang=en", 
      :body => place_fixture
    )
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/prices.json?client_id=#{Nineflats::Base.client_app_key}", 
      :body => place_prices_fixture
    )
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/reviews.json?client_id=#{Nineflats::Base.client_app_key}", 
      :body => place_reviews_fixture
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
      @place.favorites_count.should == 2
      @place.amenities_list.should == ["Internet", "Wifi (Wireless LAN)", "TV", "Air Conditioning", "Kitchen", "Washer", "Smoking allowed", "Pets allowed", "Balcony", "Dishwasher", "Fridge/freezer", "Shower/bathtub", "Baby crib", "Panoramic view"]
      @place.featured_photo_url.should == "/data/place_photos/photos/62387-1311446301/medium.jpg"
      @place.price.should == 90.0
      @place.country.should == "Portugal"
      @place.category.should == "Apartment"
      @place.place_type.should == "Entire place"
    end
    
    it "should set the links" do
      @place.self_url = "http://www.9flats.com/api/places/apt-no-centro-histrico-de-lisboa?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
      @place.full_url = "http://www.9flats.com/places/apt-no-centro-histrico-de-lisboa"
    end

    it "should set the host" do
      @place.host.class.should == Nineflats::User
      @place.host.name.should == "Paulo M."
      @place.host.slug.should == "paulo-m"
    end
  end
end