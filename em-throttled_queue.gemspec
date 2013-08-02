# -*- encoding: utf-8 -*-
require './lib/em/throttled_queue/version'

Gem::Specification.new do |gem|
  gem.name        = 'em-throttled_queue'
  gem.summary     = 'A rate-limited Queue for EventMachine'
  gem.homepage    = 'http://github.com/Burgestrand/em-throttled_queue'
  gem.authors     = ["Kim Burgestrand"]
  gem.email       = ['kim@burgestrand.se']
  gem.license     = 'X11 License'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = []
  gem.require_paths = ["lib"]

  gem.version     = EventMachine::ThrottledQueue::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9'

  gem.add_dependency 'eventmachine'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'rdiscount'
  gem.add_development_dependency 'bundler'
end
