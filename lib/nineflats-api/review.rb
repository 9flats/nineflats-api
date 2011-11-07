module Nineflats
  class Review < Base
    attr_accessor :user_text, :place_text, :place_stars, :language
    
    def initialize(json)
      @raw_data = json
      review = json.first[1]

      @user_text   = review["user_text"]
      @place_text  = review["place_text"]
      @place_stars = review["place_stars"]
      @language    = review["language"]
    end
  end
end