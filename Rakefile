require 'bundler'
Bundler::GemHelper.install_tasks

require 'yard'
YARD::Rake::YardocTask.new

require 'rake/testtask'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*.rb'
end

task :default => :spec
