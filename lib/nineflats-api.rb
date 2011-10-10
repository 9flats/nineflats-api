require 'open-uri'
require "nineflats-api/version"

module Nineflats
  module Api
    def get_data(url)
      data = ""
      begin
        open(url) do |f| 
          data = JSON.parse(f.read)
        end
      rescue => e
        data = "Something went wrong: #{e} --- This means either the data you requested is simply null, the data you entered was wrong, or the API call is broken."
      end
      data
    end
  end
end
