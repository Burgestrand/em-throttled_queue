require 'bundler/setup'

require 'jeweler'
require './lib/em/throttled_queue/version'
Jeweler::Tasks.new do |gem|
  gem.name     = "EM-Throttled Queue"
  gem.homepage = "http://github.com/Burgestrand/em-throttled_queue"
  
  gem.license  = "Ruby License" # TODO: copy/paste
  
  gem.summary = ""
  gem.authors = ["Kim Burgestrand"]
  gem.email   = "kim@burgestrand.se"
  
  gem.version = EventMachine::ThrottledQueue::VERSION
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*.rb'
end

task :default => :spec