# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

unless ENV['CI']
  require 'bump/tasks'
  require 'bundler/gem_tasks'
end

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

RuboCop::RakeTask.new

task default: %i[spec rubocop]
