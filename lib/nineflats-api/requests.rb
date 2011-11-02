module Nineflats
  module Requests
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def bookings(user_id)
        params = {:client_id => consumer.key}
        if client.access_token
          response = client.access_token.request(:get, "/api/v1/users/#{user_id}/bookings?#{Nineflats::QueryStringNormalizer.normalize(params)}")
          JSON.parse(response.body)
        else
          raise "So what?"
        end
      end
    end
  end
end
