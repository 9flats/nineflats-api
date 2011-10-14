class Fixtures

  class << self
    fixtures = Dir[File.dirname(__FILE__) + '/fixtures/*.json'].map {|f| f.gsub(/^.*\//, '').gsub(/\.json/, '')}
    fixtures.each do |fixture|
      define_method(fixture) do
        load_fixture("#{fixture}.json")
      end
    end

    def load_fixture(filename)
      File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
    end
  end

end
