module Nineflats
  class Base
    def self.client_app_key
      @@client_app_key
    end
    
    def self.client_app_key=(key)
      @@client_app_key = key
    end

    def self.base_url
      "http://api.9flats.com/api/v1"
    end
    
    def self.api_call
      raise "override me!"
    end
    
    def self.object_link(name, array)
      link = array.select{ |link|
        link["rel"] == name
      }.first["href"]
    end
  end
end
