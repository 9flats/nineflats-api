module Nineflats
  class User < Base
    attr_accessor :name, :slug, :user_photo_url, :self_url, :favorites_url
    
    def initialize(json)
      user = json.first[1]
      
      @name           = user["name"]
      @slug           = user["slug"]
      @user_photo_url = user["user_photo_url"]
      
      if user["links"]
        @self_url = user["links"].first.select{|link| link["rel"] == "self"}["href"]
        @favorites_url = user["links"].first.select{|link| link["rel"] == "favorites"}["href"]
      end
    end

    def self.fetch(slug, lang)
      User.new(Helpers.get_data(User.api_call(slug, lang)))
    end
    
    def self.api_call(slug, lang)
      base_url + "/users/#{slug}?client_id=#{Nineflats::Base.client_app_key}&lang=#{lang}"
    end
  end
end