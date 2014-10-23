RSpec.configure do |config|
  config.color = true
  config.tty   = true
  config.order = :random

  config.disable_monkey_patching!
end
