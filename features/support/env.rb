require 'bundler'
Bundler.require(:default, :development, :test)

require 'aruba/cucumber'
require 'rspec/expectations'

Before do

Object.class_eval { include RSpec::Mocks::Methods }
  @aruba_timeout_seconds = 3
end
