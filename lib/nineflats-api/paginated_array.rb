module Nineflats
  class PaginatedArray < Array
    attr_accessor :total_entries, :total_pages, :current_page, :per_page,
                  :self_url, :full_url, :next_page_url
    
    def next_page
      Nineflats::Client.places(:url => next_page_url)
    end
  end
end