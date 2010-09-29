begin
  require 'bundler/setup'
rescue LoadError
  puts "!! Bundler not found.  Please run `gem install bundler` to install and preface commands with `bundle exec`"
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "gazette"
  gem.summary = %Q{TODO: one-line summary of your gem}
  gem.description = %Q{TODO: longer description of your gem}
  gem.email = "jeff.pollard@gmail.com"
  gem.homepage = "http://github.com/Fluxx/gazette"
  gem.authors = ["Jeff Pollard"]
  gem.add_development_dependency "rspec", ">= 1.2.9"
  gem.add_development_dependency "yard", ">= 0"
  # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
end
Jeweler::GemcutterTasks.new

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies
task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
