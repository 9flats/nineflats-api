module Nineflats
  class Calendar < Base
    attr_accessor :year, :month, :days

    def initialize(calendar)
      @year  = calendar["year"]
      @month = calendar["month"]
      @days  = calendar["days"]
    end

  end
end