module Nineflats
  class Base
    def self.client_app_key
      @@client_app_key
    end
    
    def self.client_app_key=(key)
      @@client_app_key = key
    end

    def self.base_url
      "http://api.9flats.com/api"
    end
  end
end
