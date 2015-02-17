require 'bump/tasks'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

RuboCop::RakeTask.new

desc 'Push the latest commit and all tags'
task :push do
  sh 'git push && git push --tags'
end

Rake::Task[:release].enhance do Rake::Task[:push].invoke end

task default: %i[spec rubocop]
