require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Client.connect('client_app_key', 'client_app_secret')
    FakeWeb.register_uri(:get, 
      "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa?client_id=client_app_key", 
      :body => Fixtures.place
    )
    FakeWeb.register_uri(:get,
      "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=client_app_key",
      :body => Fixtures.place_reviews
    )
  end

  describe "reviews" do
    before(:each) do
      @place = Nineflats::Place.fetch('apt-no-centro-histrico-de-lisboa', 'en')
    end

    it "should add the reviews" do
      @place.reviews.length.should == 2
      @place.reviews[0].user_text.should == "Jan is a really nice outgoing person. I had a great time at his place. You should ask him for that tastey Polish vodka!!"
      @place.reviews[0].place_text.should == "It\'s a nice and lovely flat in a really great area of cologne. everything is in walking distance and it is great start to explore the cologne and its nightlife."
      @place.reviews[0].place_stars.should == 5
      @place.reviews[0].language.should == "en"
      @place.reviews[1].language.should == "de"
    end

    it "should return an empty array when there are no reviews" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=client_app_key",
        :body => '{"total_entries":0,"reviews":[]}'
      )

      @place.reviews.should == []
    end

    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=client_app_key",
        :body => '{"error":"Place not found!"}', :status => 404
      )

      expect { @place.reviews }.to raise_error(Nineflats::Error, "Place not found!")
    end

    it "should cache the reviews" do
      Nineflats::Client.should_receive(:place_reviews).and_return(JSON.parse(Fixtures.place_reviews))
      @place.reviews

      Nineflats::Client.should_not_receive(:place_reviews)
      @place.reviews
    end
  end
end
