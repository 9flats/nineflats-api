module Nineflats
  module Requests
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def user(user_id)
        url = "/api/v1/users/#{user_id}?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}"
        response = if client.access_token
          client.access_token.request(:get, url)
        else
          consumer.request(:get, url)
        end
        JSON.parse(response.body)
      end # user

      def bookings(user_id)
        params = {:client_id => consumer.key}
        if client.access_token
          response = client.access_token.request(:get, "/api/v1/users/#{user_id}/bookings?#{Nineflats::QueryStringNormalizer.normalize(params)}")
          JSON.parse(response.body)
        else
          raise "So what?"
        end
      end # bookings

    end
  end
end
