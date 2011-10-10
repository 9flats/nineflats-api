# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nineflats-api/version"

Gem::Specification.new do |s|
  s.name        = "nineflats-api"
  s.version     = Nineflats::Api::VERSION
  s.authors     = ["Lena Herrmann"]
  s.email       = ["lena@zeromail.org"]
  s.homepage    = "http://9flats.github.com/api_docs/index.html"
  s.summary     = %q{9flats API}
  s.description = %q{Let's you use the 9flats API'}

  s.rubyforge_project = "nineflats-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
