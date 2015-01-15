require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bump/tasks'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.verbose = false
end

RuboCop::RakeTask.new

desc 'Tag the next release'
task :tag do
  sh "git tag v#{Bump::Bump.current}"
end

desc 'Push the latest commit and all tags'
task :push do
  sh 'git push && git push --tags'
end

desc 'Tag and push a new release'
task release: %i[tag push]

%w[bump:major bump:minor bump:patch bump:pre].each do |bump|
  Rake::Task[bump].enhance do Rake::Task[:release].invoke end
end

task default: %i[spec rubocop]
