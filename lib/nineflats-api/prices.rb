module Nineflats
  class Prices < Base
    attr_accessor :currency, :default_price, :weekend_night_price,
                  :weekly_discount_in_percent, :monthly_discount_in_percent,
                  :seasons

    def initialize(prices)
      @raw_data = prices
      @currency                    = prices["currency"]
      @default_price               = prices["default_price"]
      @weekend_night_price         = prices["weekend_night_price"]
      @weekly_discount_in_percent  = prices["weekly_discount_in_percent"]
      @monthly_discount_in_percent = prices["monthly_discount_in_percent"]

      @seasons = prices["seasons"].collect do |season|
        Season.new(season)
      end
    end

  end
end