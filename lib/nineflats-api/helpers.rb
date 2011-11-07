require "open-uri"
require "json"

module Nineflats
  module Helpers
    def self.get_data(url)
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
  
    def self.pretty_print(data)
      self.ruby_to_html(nil, data) + "</html>"
    end
  
    private

      def self.ruby_to_html(html, object)
        html ||= "<div class=\"object\">"
        if object.is_a?(Hash)
          html += "<div class=\"hash\">"
          object.each do |key, value| 
            html += "<div class=\"key\">#{key}</div>"
            html += "<div class=\"value\">"
            html = ruby_to_html(html, value)
            html += "</div>"
          end
          html += "</div>"
        elsif object.is_a?(Array)
          html += "<div class=\"array\">"
          object.each do |element|
            html += "<div class=\"element\">"
            html = ruby_to_html(html, element)
            html += "</div>"
          end
          html += "</div>"
        elsif object.is_a?(Nineflats::Base)
          html = ruby_to_html(html, object.raw_data)
        else
          html += "<div class=\"string\">#{object.to_s}</div>"
        end
        html
      end
  end
end
