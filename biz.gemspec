require File.expand_path('../lib/biz/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'biz'
  gem.version     = Biz::VERSION
  gem.authors     = ['Craig Little', 'Alex Stone']
  gem.email       = %w[clittle@zendesk.com astone@zendesk.com]
  gem.summary     = %[Time calculations with business hours]
  gem.description = %[A gem for manipulating time with business hours.]
  gem.homepage    = 'https://github.com/zendesk/biz'

  gem.files = Dir['lib/**/*', 'README.md']

  gem.license = 'Copyright Zendesk. All Rights Reserved.'

  gem.add_runtime_dependency 'adamantium', '~> 0.0'
  gem.add_runtime_dependency 'equalizer',  '~> 0.0'
  gem.add_runtime_dependency 'memoizable', '~> 0.0'
  gem.add_runtime_dependency 'tzinfo'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0'
end
