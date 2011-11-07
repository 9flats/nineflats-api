module Nineflats
  class Booking < Base

    attr_accessor :checkin_date, :checkout_date, :nights, :number_of_guests, :status
    attr_accessor :host, :links, :place

    def initialize(json)
      @raw_data = json
      booking = json.first[1]

      @checkin_date     = booking["checkin_date"]
      @checkout_date    = booking["checkout_date"]
      @nights           = booking["nights"]
      @number_of_guests = booking["number_of_guests"]
      @status           = booking["status"]

      @host   = User.new({"user" => booking["host"]})
      @place  = Place.new({"place" => booking["place"]})

      @links = {}
      booking['links'].each do |link|
        @links[link['rel']] = link['href']
      end
    end

  end
end