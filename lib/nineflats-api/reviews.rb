module Nineflats
  class Reviews < Base
    attr_accessor :reviews, :total
    
    def initialize(json)
      @total = json["total"]
      @reviews = []
      json["reviews"].each do |review|
        @reviews << Review.new(review)
      end
    end
    
    def self.api_call(slug)
      base_url + "/places/#{slug}/reviews.json?client_id=#{Nineflats::Base.client_app_key}"
    end
  end
end