# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{em-throttled_queue}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kim Burgestrand"]
  s.date = %q{2011-02-13}
  s.email = %q{kim@burgestrand.se}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    ".yardopts",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "em-throttled_queue.gemspec",
    "lib/em/throttled_queue.rb",
    "lib/em/throttled_queue/version.rb",
    "lib/eventmachine/throttled_queue.rb",
    "spec/throttled_queue.rb"
  ]
  s.homepage = %q{http://github.com/Burgestrand/em-throttled_queue}
  s.licenses = ["X11 License"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("~> 1.9")
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{A rate-limited Queue for EventMachine}
  s.test_files = [
    "spec/throttled_queue.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rdiscount>, [">= 0"])
    else
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rdiscount>, [">= 0"])
    end
  else
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rdiscount>, [">= 0"])
  end
end
