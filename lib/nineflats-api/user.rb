module Nineflats
  class User < Base
    attr_accessor :name, :slug, :user_photo_url, :favorites,
                  :self_url, :favorites_url, :full_url

    def initialize(json)
      @raw_data = json
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

    def bookings
      Client.user_bookings(self.slug)
    end

    def favorites(options={})
      unless options[:reload]
        return @favorites if @favorites
      end
      @favorites = Client.user_favorites(self.slug)
    end

    def self.find_by_slug(slug)
      Client.user(slug)
    end

    # def self.bookings(user_id)
    #   Client.bookings(user_id)
    # end
  end
end