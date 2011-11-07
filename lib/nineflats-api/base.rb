module Nineflats
  class Base
    def self.client_app_key
      @@client_app_key
    end
    
    def self.client_app_key=(key)
      @@client_app_key = key
    end

    def self.object_link(name, array)
      array.select{ |link|
        link["rel"] == name
      }.first["href"]
    end
  end
end
