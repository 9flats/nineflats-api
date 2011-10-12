module Nineflats
  class Season
    attr_accessor :from, :to, :price, :weekend_night_price
    
    def initialize(json)
      season = json.first[1]
      
      @from                = season["from"]
      @to                  = season["to"]
      @price               = season["price"]
      @weekend_night_price = season["weekend_night_price"]
    end

  end
end