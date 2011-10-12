module Nineflats
  class Base
    class << self
      def client_app_key
        @@client_app_key
      end
      def client_app_key=(key)
        @@client_app_key = key
      end
    end
  end
end
