require "nineflats-api/helpers"

module Nineflats
  class Place
    def initialize(json)
      # json.each
    end

    def self.fetch(slug, lang)
      Place.new(Helpers.get_data(place_url(slug, lang)))
    end
    
    def self.place_url(slug, lang)
      "http://api.9flats.com/api/places/#{slug}.json?client_id=#{settings.client_app_key}&language=#{lang}"
    end
  end
end