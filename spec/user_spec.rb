require 'spec_helper'

describe Nineflats::User do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/users/jana-k-1.json?client_id=#{Nineflats::Base.client_app_key}&lang=en", 
      :body => user_fixture
    )
  end
  
  describe "fetch" do
    before(:each) do
      @user = Nineflats::User.fetch('jana-k-1', 'en')
    end
    
    it "should return a user" do
      @user.class.should == Nineflats::User
    end
    
    it "should set all the attributes" do
      @user.name.should == "Jana K."
      @user.slug.should == "jana-k-1"
      @user.user_photo_url.should == "http://img2.9flats.com/users/photos/11405-1311181665/medium.jpg"
    end
    
    it "should set the links" do
      @user.self_url = "http://www.9flats.com/places/jana-k-1"
      @user.favorites_url = "http://www.9flats.com/places/jana-k-1/favorites"
    end
  end
end