Dir[File.dirname(__FILE__) + "/nineflats-api/**/*.rb"].sort.each { |f| require File.expand_path(f) }
