require 'spec_helper'

describe Nineflats::User do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
    FakeWeb.register_uri(:get, 
      "http://api.9flats.com/api/v1/users/jana-k-1?client_id=#{Nineflats::Base.client_app_key}", 
      :body => Fixtures.user
    )
  end
  
  describe "fetch" do
    before(:each) do
      @user = Nineflats::User.fetch('jana-k-1')
    end
    
    it "should return a user" do
      @user.class.should == Nineflats::User
    end
    
    it "should set all the attributes" do
      @user.name.should == "Jana K."
      @user.slug.should == "jana-k-1"
      @user.user_photo_url.should == "http://img3.9flats.com/users/photos/11405-1311181665/medium.jpg"
    end
    
    it "should set the links" do
      @user.self_url.should == "http://api.9flats.com/api/v1/users/jana-k-1?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
      @user.full_url.should == "http://www.9flats.com/users/jana-k-1"
      @user.favorites_url.should == "http://api.9flats.com/api/v1/users/jana-k-1/favorites?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
    end
  end
  
  describe "favorites" do
    before(:each) do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/users/jana-k-1/favorites?client_id=#{Nineflats::Base.client_app_key}", 
        :body => Fixtures.user_favorites
      )
      @user = Nineflats::User.fetch('jana-k-1')
    end
    
    it "should add the favorite places" do
      @user.favorites.length.should == 7
      
      @user.favorites[0].class.should == Nineflats::Place
      @user.favorites[0].name.should == "Maison de charme"
      @user.favorites[0].city.should == "Olargues"
      @user.favorites[1].slug.should == "55qm-loftwohnung"
    end
    
    it "should return an empty array when there are no favorites" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/users/jana-k-1/favorites?client_id=#{Nineflats::Base.client_app_key}", 
        :body => '{"places":[]}'
      )
      
      @user.favorites.should == []
    end
    
    it "should return nil when the API call fails" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/users/jana-k-1/favorites?client_id=#{Nineflats::Base.client_app_key}", 
        :body => ''
      )
      
      @user.favorites.should == nil
    end
    
    it "should cache the reviews" do
      Nineflats::Helpers.should_receive(:get_data).and_return(JSON.parse(Fixtures.user_favorites))
      @user.favorites
      
      Nineflats::Helpers.should_not_receive(:get_data)
      @user.favorites
    end
  end
end