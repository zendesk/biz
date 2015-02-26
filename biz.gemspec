require File.expand_path('../lib/biz/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'biz'
  gem.version     = Biz::VERSION
  gem.authors     = ['Craig Little', 'Alex Stone']
  gem.email       = %w[clittle@zendesk.com astone@zendesk.com]
  gem.summary     = %[Business hours calculations]
  gem.description = %[Time calculations using business hours.]
  gem.homepage    = 'https://github.com/zendesk/biz'
  gem.license     = 'Apache 2.0'
  gem.files       = Dir['lib/**/*', 'README.md']

  gem.required_ruby_version = '>= 2.0'

  gem.add_runtime_dependency 'abstract_type', '~> 0.0.0'
  gem.add_runtime_dependency 'equalizer',     '~> 0.0.0'
  gem.add_runtime_dependency 'memoizable',    '~> 0.4.0'
  gem.add_runtime_dependency 'tzinfo'

  gem.add_development_dependency 'rake',  '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
end
