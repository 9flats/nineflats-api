require 'nineflats-api/requests'
module Nineflats
  class Client < Base
    attr_accessor :access_token
    attr_reader :consumer

    include Requests

    def self.connect(api_key, api_secret, options={})
      @@client = Client.new(api_key, api_secret, options)
      if block_given?
        yield @@client
      end
      @@client
    end

    def self.api_site_url
      @@api_site_url ||= "http://www.9flats.com"
    end

    def self.api_site_url=(url)
      @@api_site_url = url
    end

    def self.client
      @@client
    end

    def self.consumer
      @@client.consumer
    end

    def request_token(callback_url)
      @consumer.get_request_token({:oauth_callback => callback_url})
    end

    def exchange_access_token(request_token, verifier)
      request_token.get_access_token(:oauth_verifier => verifier)
    end

    def authorized?
      !access_token.nil?
    end

  private

    def initialize(api_key, api_secret, options={})
      @consumer = ::OAuth::Consumer.new(api_key, api_secret, {
        :site               => Nineflats::Client.api_site_url,
        :scheme             => :header,
        :http_method        => :post
       })
      @access_token = options[:access_token]
    end

  end
end
