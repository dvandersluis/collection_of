require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

task :benchmarks do
  Dir['benchmarks/*.rb'].each do |benchmark|
    puts "Running #{benchmark}..."
    system("bundle exec ruby #{benchmark}")
  end
end
