module Nineflats
  class User < Base
    attr_accessor :name, :slug, :user_photo_url, :favorites,
                  :self_url, :favorites_url, :full_url
    
    def initialize(json)
      user = json.first[1]
      
      @name           = user["name"]
      @slug           = user["slug"]
      @user_photo_url = user["user_photo_url"]
      
      if user["links"]
        @self_url      = Nineflats::Base.object_link("self", user["links"])
        @full_url      = Nineflats::Base.object_link("full", user["links"])
        @favorites_url = Nineflats::Base.object_link("favorites", user["links"])
      end
    end
    
    def favorites
      return @favorites if @favorites
      
      json = Helpers.get_data(favorites_url)
      
      if json && json["places"]
        @favorites = json["places"].collect do |place_hash|
          Place.new(place_hash)
        end
      end
    end

    def self.fetch(slug)
      User.new(Helpers.get_data(User.api_call(slug)))
    end
        
    def self.api_call(slug)
      base_url + "/users/#{slug}?client_id=#{Nineflats::Base.client_app_key}"
    end
  end
end