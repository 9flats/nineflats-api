module Nineflats
  class Calendar < Base
    attr_accessor :year, :month, :days
    
    def initialize(json)
      calendar = json.first[1]

      @year  = calendar["year"]
      @month = calendar["month"]
      @days  = calendar["days"]
    end
    
    def self.api_call(slug, year, month)
      base_url + "/places/#{slug}/calendar/#{year}/#{month}?client_id=#{Nineflats::Base.client_app_key}"
    end
  end
end