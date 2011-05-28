require 'bundler'
Bundler.require(:default, :development, :test)

require 'aruba/cucumber'
require 'rspec/expectations'

Before do
  @aruba_timeout_seconds = 3
end
