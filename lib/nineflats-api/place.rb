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

    def self.search(params = nil)
      params ||= {}

      queries = params.collect do |key, value|
        "&search[#{key}]=#{value}"
      end

      search_url = base_url + "/places?client_id=#{Nineflats::Base.client_app_key}" + queries.join

      Place.search_result(search_url)
    end

    def self.search_result(search_url)
      json = Helpers.get_data(search_url)

      places = json["places"].collect do |place_json|
        Place.new(place_json)
      end

      result = Nineflats::PaginatedArray.new(places)

      result.total_entries = json["total_entries"]
      result.total_pages   = json["total_pages"]
      result.current_page  = json["current_page"]
      result.per_page      = json["per_page"]

      result.self_url      = Nineflats::Base.object_link("self", json["links"])
      result.full_url      = Nineflats::Base.object_link("full", json["links"])
      result.next_page_url = Nineflats::Base.object_link("next_page", json["links"])
      result
    end

    def self.fetch(slug, lang)
      Place.new(Helpers.get_data(Place.api_call(slug, lang)))
    end

    def prices
      return @prices if @prices

      json = Helpers.get_data(Prices.api_call(slug))

      @prices = Prices.new(json) if json && json["place_prices"]
    end

    def reviews
      return @reviews if @reviews

      json = Helpers.get_data(Review.api_call(slug))

      if json && json["reviews"]
        @reviews = json["reviews"].collect do |review_hash|
          Review.new(review_hash)
        end
      end
    end

    def photos
      return @photos if @photos

      json = Helpers.get_data(Photo.api_call(slug))

      if json && json["place_photos"]
        @photos = json["place_photos"].collect do |photo_hash|
          Photo.new(photo_hash)
        end
      end
    end

    def calendar(year, month)
      json = Helpers.get_data(Calendar.api_call(slug, year, month))

      Calendar.new(json) if json && json["calendar"]
    end

    def self.api_call(slug, lang)
      base_url + "/places/#{slug}?client_id=#{Nineflats::Base.client_app_key}&lang=#{lang}"
    end
  end
end