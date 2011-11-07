module Nineflats
  module Requests
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def places(search_options)
        response = if search_options[:url]
          consumer.request(:get, search_options[:url])
        else
          consumer.request(:get, "/api/v1/places?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key, :search => search_options})}")
        end
        json = JSON.parse(response.body)
        if json["places"]
          places = json["places"].collect do |place_hash|
            Place.new(place_hash)
          end
          result = Nineflats::PaginatedArray.new(places)

          result.total_entries = json["total_entries"]
          result.total_pages   = json["total_pages"]
          result.current_page  = json["current_page"]
          result.per_page      = json["per_page"]

          result.self_url      = Nineflats::Base.object_link("self", json["links"])
          result.full_url      = Nineflats::Base.object_link("full", json["links"])
          result.next_page_url = Nineflats::Base.object_link("next_page", json["links"])
          result
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

      def place(slug, options={})
        params = {:client_id => consumer.key}
        params[:lang] = options[:language] if options[:language]
        url = "/api/v1/places/#{slug}?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}"
        response = if client.access_token
          client.access_token.request(:get, url)
        else
          consumer.request(:get, url)
        end
        Nineflats::Place.new(JSON.parse(response.body))
      end

      def place_calendar(place_slug, year, month)
        response = consumer.request(:get, "/api/v1/places/#{place_slug}/calendar/#{year}/#{month}?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}")
        json = JSON.parse(response.body)
        if json["calendar"]
          Calendar.new(json['calendar'])
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

      def place_prices(place_slug)
        response = consumer.request(:get, "/api/v1/places/#{place_slug}/prices?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}")
        json = JSON.parse(response.body)
        if json["place_prices"]
          Prices.new(json['place_prices'])
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

      def place_reviews(place_slug)
        response = consumer.request(:get, "/api/v1/places/#{place_slug}/reviews?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}")
        json = JSON.parse(response.body)
        if json["reviews"]
          json["reviews"].collect do |review_hash|
            Review.new(review_hash)
          end
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

      def place_photos(place_slug)
        response = consumer.request(:get, "/api/v1/places/#{place_slug}/photos?#{Nineflats::QueryStringNormalizer.normalize({:client_id => consumer.key})}")
        json = JSON.parse(response.body)
        if json["place_photos"]
          json["place_photos"].collect do |photo_hash|
            Photo.new(photo_hash)
          end
        else
          raise Nineflats::Error.new(json['error'])
        end
      end

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
