# frozen_string_literal: true

require File.expand_path('lib/biz/version', __dir__)

Gem::Specification.new do |gem|
  gem.name        = 'biz'
  gem.version     = Biz::VERSION
  gem.authors     = ['Craig Little', 'Alex Stone']
  gem.email       = %w[clittle@zendesk.com astone@zendesk.com]
  gem.summary     = 'Business hours calculations'
  gem.description = 'Time calculations using business hours.'
  gem.homepage    = 'https://github.com/zendesk/biz'
  gem.license     = 'Apache 2.0'
  gem.files       = Dir['lib/**/*', 'README.md']

  gem.required_ruby_version = '>= 2.3'

  gem.add_dependency 'tzinfo'
end
