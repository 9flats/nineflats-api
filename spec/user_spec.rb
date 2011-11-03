require 'spec_helper'

describe Nineflats::User do

  describe "requesting a user" do
    before(:each) do
      Nineflats::Client.connect('client_app_key', 'client_app_secret')
      FakeWeb.register_uri(:get, 
        "http://www.9flats.com/api/v1/users/jana-k-1?client_id=client_app_key", 
        :body => Fixtures.user
      )
    end

    it "should succeed" do
      user = Nineflats::User.find_by_slug('jana-k-1')
      user.class.should == Nineflats::User
      user.name.should == 'Jana K.'
      user.slug.should == "jana-k-1"
      user.user_photo_url.should == "http://img3.9flats.com/users/photos/11405-1311181665/medium.jpg"
      user.self_url.should == "http://api.9flats.com/api/v1/users/jana-k-1?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
      user.full_url.should == "http://www.9flats.com/users/jana-k-1"
      user.favorites_url.should == "http://api.9flats.com/api/v1/users/jana-k-1/favorites?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
    end
  end

  describe "favorites" do
    before(:each) do
      Nineflats::Client.connect('client_app_key', 'client_app_secret')
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/users/jana-k-1?client_id=client_app_key",
        :body => Fixtures.user
      )
      @user = Nineflats::User.find_by_slug('jana-k-1')
    end

    it "should add the favorite places" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/users/jana-k-1/favorites?client_id=client_app_key",
        :body => Fixtures.user_favorites
      )
      @user.favorites.length.should == 7

      @user.favorites[0].class.should == Nineflats::Place
      @user.favorites[0].name.should == "Maison de charme"
      @user.favorites[0].city.should == "Olargues"
      @user.favorites[1].slug.should == "55qm-loftwohnung"
    end

    it "should return an empty array when there are no favorites" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/users/jana-k-1/favorites?client_id=client_app_key",
        :body => '{"places":[]}'
      )

      @user.favorites.should == []
    end

    it "should cache the favorites" do
      Nineflats::Client.should_receive(:user_favorites).and_return(JSON.parse(Fixtures.user_favorites))
      @user.favorites

      Nineflats::Client.should_not_receive(:user_favorites)
      @user.favorites
    end
  end

  describe "bookings" do
    before(:each) do
      Nineflats::Client.connect('client_app_key', 'client_app_secret')
      Nineflats::Client.client.access_token = OAuth::AccessToken.new(Nineflats::Client.consumer, 'access_token', "access_token_secret")
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/users/jana-k-1?client_id=client_app_key",
        :body => Fixtures.user
      )
      @user = Nineflats::User.find_by_slug('jana-k-1')
    end

    it "return bookings" do
      FakeWeb.register_uri(:get,
        "http://www.9flats.com/api/v1/users/jana-k-1/bookings?client_id=client_app_key",
        :body => Fixtures.user_bookings
      )
      @user.bookings.length.should == 2
    end
  end

end
