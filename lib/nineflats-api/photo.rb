module Nineflats
  class Photo < Base
    attr_accessor :title, :caption, :url
    
    def initialize(json)
      photo = json.first[1]

      @title   = photo["title"]
      @caption = photo["caption"]
      @url     = photo["url"]
    end
    
    def self.api_call(slug)
      base_url + "/places/#{slug}/photos.json?client_id=#{Nineflats::Base.client_app_key}"
    end
  end
end