class Fixtures
  def self.place_prices
    '{
      "place_prices": {
        "currency": "EUR",
        "default_price": 90.0,
        "weekend_night_price": 90.0,
        "weekly_discount_in_percent": 5.55,
        "monthly_discount_in_percent": 11.11,
        "seasons": [{
          "season": {
            "from": "2011-09-05",
            "to": "2011-09-30",
            "price": 100.0,
            "weekend_night_price": 110.0
          }
        },
        {
          "season": {
            "from": "2011-10-01",
            "to": "2011-10-31",
            "price": 75.0,
            "weekend_night_price": 75.0
          }
        }]
      }
    }'
  end
end
