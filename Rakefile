require 'bump/tasks'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

RuboCop::RakeTask.new

task default: %i[spec rubocop]
