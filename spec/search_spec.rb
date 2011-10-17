require 'spec_helper'

describe Nineflats::Place do
  before(:each) do
    Nineflats::Base.stub!(:client_app_key).and_return("WfKWrPywnEbMhlifGlrsLu2ULfvTwxrKQji5eg0S")
  end
  
  describe "search" do
    it "should build the search query from the parameters" do
      Nineflats::Helpers.should_receive(:get_data).with(
        "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[query]=Siena&search[number_of_beds]=3&search[currency]=USD"
      ).and_return(JSON.parse(Fixtures.search_result))
      Nineflats::Place.search({:query => "Siena", :number_of_beds => 3, :currency => "USD"})
    end
  end
  
  context "correct query" do
    before(:each) do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[query]=Siena&search[number_of_beds]=3&search[currency]=USD", 
        :body => Fixtures.search_result
      )
      @result = Nineflats::Place.search({:query => "Siena", :number_of_beds => 3, :currency => "USD"})
    end
    
    it "should return an array of places" do
      @result.length.should == 9
      @result.first.class.should == Nineflats::Place
      @result.first.city.should == "Siena"
      @result.first.slug.should == "splendida-villa-toscana-"
    end
    
    it "should return an array that has more information about the search result" do
      @result.total_entries.should == 28
      @result.total_pages.should == 4
      @result.current_page.should == 1
      @result.per_page.should == 9
      @result.self_url.should == "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[amenities]=&search[bb_ne]=&search[bb_sw]=&search[currency]=USD&search[end_date]=&search[exclude_place_id]=&search[lat]=43.3186614&search[lng]=11.3305135&search[number_of_bathrooms]=0&search[number_of_bedrooms]=0&search[number_of_beds]=3&search[page]=1&search[place_type]=&search[price_max]=&search[price_min]=&search[query]=siena&search[radius]=20&search[sort_by]=top_ranking&search[start_date]=&search[woeid]="
      @result.full_url.should == "http://www.9flats.com/searches?search[amenities]=&search[bb_ne]=&search[bb_sw]=&search[currency]=USD&search[end_date]=&search[exclude_place_id]=&search[lat]=43.3186614&search[lng]=11.3305135&search[number_of_bathrooms]=0&search[number_of_bedrooms]=0&search[number_of_beds]=3&search[page]=1&search[place_type]=&search[price_max]=&search[price_min]=&search[query]=siena&search[radius]=20&search[sort_by]=top_ranking&search[start_date]=&search[woeid]="
      @result.next_page_url.should == "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[amenities]=&search[bb_ne]=&search[bb_sw]=&search[currency]=USD&search[end_date]=&search[exclude_place_id]=&search[lat]=43.3186614&search[lng]=11.3305135&search[number_of_bathrooms]=0&search[number_of_bedrooms]=0&search[number_of_beds]=3&search[page]=2&search[place_type]=&search[price_max]=&search[price_min]=&search[query]=siena&search[radius]=20&search[sort_by]=top_ranking&search[start_date]=&search[woeid]="
    end
    
    it "should return an array that gives access to the next page" do
      FakeWeb.register_uri(:get, 
        "http://api.9flats.com/api/v1/places?client_id=#{Nineflats::Base.client_app_key}&search[amenities]=&search[bb_ne]=&search[bb_sw]=&search[currency]=USD&search[end_date]=&search[exclude_place_id]=&search[lat]=43.3186614&search[lng]=11.3305135&search[number_of_bathrooms]=0&search[number_of_bedrooms]=0&search[number_of_beds]=3&search[page]=2&search[place_type]=&search[price_max]=&search[price_min]=&search[query]=siena&search[radius]=20&search[sort_by]=top_ranking&search[start_date]=&search[woeid]=",
        :body => Fixtures.search_result
      )
      
      @result.next_page.length.should == 9
      @result.next_page.first.class.should == Nineflats::Place
      @result.next_page.first.city.should == "Siena"
      @result.next_page.first.slug.should == "splendida-villa-toscana-"
    end
  end
end