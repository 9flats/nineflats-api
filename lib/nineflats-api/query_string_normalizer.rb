module Nineflats
  module QueryStringNormalizer
    def self.normalize(query)
      Array(query).map do |key, value|
        if value.nil?
          key.to_s
        elsif value.is_a?(Array)
          value.map {|v| "#{key}=#{URI.encode(v.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"}
        else
          HashConversions.to_params(key => value)
        end
      end.flatten.sort.join('&')
    end
  end

  module HashConversions
    def self.to_params(hash)
      params = hash.map { |k,v| normalize_param(k,v) }.join
      params.chop! # trailing &
      params
    end

    def self.normalize_param(key, value)
      param = ''
      stack = []

      if value.is_a?(Array)
        param << value.map { |element| normalize_param("#{key}[]", element) }.join
      elsif value.is_a?(Hash)
        stack << [key,value]
      else
        param << "#{key}=#{URI.encode(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}&"
      end

      stack.each do |parent, hash|
        hash.each do |key, value|
          if value.is_a?(Hash)
            stack << ["#{parent}[#{key}]", value]
          else
            param << normalize_param("#{parent}[#{key}]", value)
          end
        end
      end

      param
    end
  end
end
