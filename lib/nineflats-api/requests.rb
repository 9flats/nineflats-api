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
        Nineflats::User.new(JSON.parse(response.body))
      end

      def user_favorites(user_id)
        response = consumer.request(:get, "/api/v1/users/#{user_id}/favorites?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}")
        json = JSON.parse(response.body)
        if json["places"]
          json["places"].collect do |place_hash|
            Place.new(place_hash)
          end
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

      def user_bookings(user_id)
        raise Nineflats::NotAuthenticatedException.new("User is not authenticated yet!") unless Client.client.authorized?

        params = {:client_id => consumer.key}
        response = client.access_token.request(:get, "/api/v1/users/#{user_id}/bookings?#{Nineflats::QueryStringNormalizer.normalize(params)}")
        json = JSON.parse(response.body)
        if json && json["bookings"]
          json["bookings"].collect do |booking_hash|
            Booking.new(booking_hash)
          end
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

    end
  end
end
