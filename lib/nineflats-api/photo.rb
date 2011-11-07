module Nineflats
  class Photo < Base
    attr_accessor :title, :caption, :url
    
    def initialize(json)
      photo = json.first[1]

      @title   = photo["title"]
      @caption = photo["caption"]
      @url     = photo["url"]
    end
  end
end