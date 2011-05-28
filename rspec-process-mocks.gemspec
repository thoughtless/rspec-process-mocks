# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/process_mocks/version"

Gem::Specification.new do |s|
  s.name        = "rspec-process-mocks"
  s.version     = RSpec::ProcessMocks::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Cortens"]
  s.email       = "paul@thoughtless.ca"
  s.homepage    = "http://github.com/thoughtless/rspec-process-mocks"
  s.summary     = "rspec-process-mocks-#{RSpec::ProcessMocks::Version::STRING}"
  s.description = "Add-on for RSpec's 'test double' framework, with support for stubbing and mocking within child processes"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [ "README.md" ]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end

