# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gazette/version"

Gem::Specification.new do |s|
  s.name        = "gazette"
  s.version     = Gazette::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Pollard"]
  s.email       = ["jeff.pollard@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Simple Ruby wrapper gem to interact with the Instapaper API.}
  s.description = %q{Simple Ruby wrapper gem to interact with the Instapaper API.  Supports authenticate and add API methods, as well as https, jsonp and all other features of the API.}

  s.rubyforge_project = "gazette"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency(%q<yard>, ["> 0.6.0"])
  s.add_dependency(%q<bluecloth>, ["> 2.0.0"])
  
  s.add_development_dependency(%q<rspec>, ["~> 2.4.0"])
  s.add_development_dependency(%q<rake>)
  s.add_development_dependency(%q<rcov>, ["~> 0.9.0"])
  s.add_development_dependency(%q<fakeweb>, ["> 1.2.0"])
  
end