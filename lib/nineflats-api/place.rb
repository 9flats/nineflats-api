module Nineflats
  class Place < Base
    attr_accessor :name, :city, :slug, :zipcode, :number_of_beds, :number_of_bedrooms,
                  :currency, :lat, :lng, :district, :number_of_bathrooms,
                  :minimum_nights, :maximum_nights, :bed_type, :content_language,
                  :size, :house_rules, :pets_around, :bathroom_type, :cleaning_fee,
                  :charge_per_extra_person_limit, :favorites_count, :amenities_list,
                  :featured_photo_url, :price, :charge_per_extra_person, :country,
                  :category, :place_type, :bed_type, :bathroom_type, :description,
                  :host, :links, :prices, :reviews, :photos

    def initialize(json)
      place = json.first[1]

      @name                          = place["name"]
      @city                          = place["city"]
      @currency                      = place["currency"]
      @slug                          = place["slug"]
      @zipcode                       = place["zipcode"]
      @number_of_beds                = place["number_of_beds"]
      @number_of_bedrooms            = place["number_of_bedrooms"]
      @number_of_bathrooms           = place["number_of_bathrooms"]
      @charge_per_extra_person       = place["charge_per_extra_person"]
      @content_language              = place["content_language"]
      @minimum_nights                = place["minimum_nights"]
      @maximum_nights                = place["maximum_nights"]
      @bed_type                      = place["bed_type"]
      @size                          = place["size"]
      @house_rules                   = place["house_rules"]
      @pets_around                   = place["pets_around"]
      @bathroom_type                 = place["bathroom_type"]
      @cleaning_fee                  = place["cleaning_fee"]
      @charge_per_extra_person_limit = place["charge_per_extra_person_limit"]
      @favorites_count               = place["favorites_count"]
      @amenities_list                = place["amenities_list"]
      @featured_photo_url            = place["featured_photo_url"]
      @price                         = place["price"]
      @country                       = place["country"]
      @category                      = place["category"]
      @place_type                    = place["place_type"]
      @lat                           = place["lat"]
      @lng                           = place["lng"]
      @district                      = place["district"]
      @description                   = place["description"]

      @host = User.new({"user" => place["host"]}) if place["host"]

      @links = {}
      place['links'].each do |link|
        @links[link['rel']] = link['href']
      end
    end

    def self.search(params={})
      Nineflats::Client.places(params)
    end


    def self.fetch(slug, lang)
      Nineflats::Client.place(slug, :language => lang)
    end

    def prices
      return @prices if @prices
      @prices = Nineflats::Client.place_prices(@slug)
    end

    def reviews
      return @reviews if @reviews
      @reviews = Nineflats::Client.place_reviews(@slug)
    end

    def photos
      return @photos if @photos
      @photos = Nineflats::Client.place_photos(@slug)
    end

    def calendar(year, month)
      Nineflats::Client.place_calendar(@slug, year, month)
    end

  end
end
