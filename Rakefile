require 'bundler'
require 'yard'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
YARD::Rake::YardocTask.new
RSpec::Core::RakeTask.new(:spec)

desc  "Check code coverage with rcov"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
end

task :default => :spec