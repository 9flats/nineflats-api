module Nineflats
  class User < Base
    attr_accessor :name, :slug
    
    def initialize(name, slug)
      @name = name
      @slug = slug
    end

    def self.fetch(slug, lang)
      User.new(Helpers.get_data(user_url(slug, lang)))
    end
    
    def self.user_url(slug, lang)
      base_url + "/places/#{slug}.json?client_id=#{Nineflats::Base.client_app_key}&language=#{lang}"
    end
  end
end