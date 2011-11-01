module Nineflats
  class Client < Base
    # API_BASE_URI = "api.9flats.com/api/v1"
    # API_BASE_URI = "http://localhost.com:3000/api/v1"
    # WEB_BASE_URI = "http://www.9flats.com"
    WEB_BASE_URI = "http://localhost.com:3000"

    attr_accessor :request_token
    attr_accessor :access_token
    attr_reader :consumer

    def self.connect(api_key, api_secret, options={})
      @@client = Client.new(api_key, api_secret, options)
      if block_given?
        yield @@client
      end
      @@client
    end

    def self.client
      @@client
    end

    def request_token(callback_url)
      @consumer.get_request_token({:oauth_callback => callback_url})
    end

    def access_token(request_token, verifier)
      @access_token ||= @consumer.get_access_token(request_token, )
    end

  private

    def initialize(api_key, api_secret, options={})
      @consumer = ::OAuth::Consumer.new(api_key, api_secret, {
        :site               => WEB_BASE_URI,
        :scheme             => :header,
        :http_method        => :post
       })
      # Client.default_options[:simple_oauth] = { :consumer => @consumer, :method => 'HMAC-SHA1' }.merge(options)
    end

  end
end
