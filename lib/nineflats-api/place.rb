module Nineflats
  class Place < Base
    attr_accessor :name, :city, :slug, :zipcode, :number_of_beds, :number_of_bedrooms, 
                  :currency, :lat, :lng, :district, :number_of_bathrooms, 
                  :minimum_nights, :maximum_nights, :bed_type, :content_language,
                  :size, :house_rules, :pets_around, :bathroom_type, :cleaning_fee, 
                  :charge_per_extra_person_limit, :favorites_count, :amenities_list,
                  :featured_photo_url, :price, :charge_per_extra_person, :country,
                  :category, :place_type, :bed_type, :bathroom_type,
                  :host, :self_url, :full_url, :prices, :reviews
    
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

      @host = User.new({"user"=>place["host"]})

      @self_url = place["links"].first.select{|link| link["rel"] == "self"}["href"]
      @full_url = place["links"].first.select{|link| link["rel"] == "full"}["href"]
    end

    def self.fetch(slug, lang)
      Place.new(Helpers.get_data(Place.api_call(slug, lang)))
    end
    
    def prices
      @prices = Prices.new(Helpers.get_data(Prices.api_call(slug)))
    end
    
    def reviews
      @reviews = Reviews.new(Helpers.get_data(Reviews.api_call(slug)))
    end
    
    def self.api_call(slug, lang)
      base_url + "/places/#{slug}.json?client_id=#{Nineflats::Base.client_app_key}&lang=#{lang}"
    end
  end
end