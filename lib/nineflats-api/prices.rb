module Nineflats
  class Prices < Base
    attr_accessor :currency, :default_price, :weekend_night_price, 
                  :weekly_discount_in_percent, :monthly_discount_in_percent 
    
    def initialize(json)
      prices = json.first[1]
      
      @currency                    = prices["currency"]
      @default_price               = prices["default_price"]
      @weekend_night_price         = prices["weekend_night_price"]
      @weekly_discount_in_percent  = prices["weekly_discount_in_percent"]
      @monthly_discount_in_percent = prices["monthly_discount_in_percent"]
    end
    
    def self.api_call(slug)
      base_url + "/places/#{slug}/prices.json?client_id=#{Nineflats::Base.client_app_key}"
    end
  end
end