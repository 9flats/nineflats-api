require 'spec_helper'

describe Nineflats::Client do

  describe "requesting a user" do
    before(:each) do
      Nineflats::Client.connect('client_app_key', 'client_app_secret')
      FakeWeb.register_uri(:get, 
        "http://www.9flats.com/api/v1/users/jana-k-1?client_id=client_app_key", 
        :body => Fixtures.user
      )
    end

    it "should succeed" do
      user = Nineflats::Client.user('jana-k-1')
      user.class.should == Nineflats::User
      user.name.should == 'Jana K.'
      user.slug.should == "jana-k-1"
      user.user_photo_url.should == "http://img3.9flats.com/users/photos/11405-1311181665/medium.jpg"
      user.self_url.should == "http://api.9flats.com/api/v1/users/jana-k-1?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
      user.full_url.should == "http://www.9flats.com/users/jana-k-1"
      user.favorites_url.should == "http://api.9flats.com/api/v1/users/jana-k-1/favorites?client_id=WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S"
    end
  end
end
