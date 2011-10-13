require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa?client_id=#{Nineflats::Base.client_app_key}&lang=en", 
      :body => place_fixture
    )
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=#{Nineflats::Base.client_app_key}", 
      :body => place_reviews_fixture
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
        "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=#{Nineflats::Base.client_app_key}", 
        :body => '{"total":0,"reviews":[]}'
      )
      
      @place.reviews.should == []
    end
    
    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/places/apt-no-centro-histrico-de-lisboa/reviews?client_id=#{Nineflats::Base.client_app_key}", 
        :body => ''
      )
      
      @place.reviews.should == nil
    end
    
    it "should cache the reviews" do
      Nineflats::Helpers.should_receive(:get_data).and_return(JSON.parse(place_reviews_fixture))
      @place.reviews

      Nineflats::Helpers.should_not_receive(:get_data)
      @place.reviews
    end 
  end
end