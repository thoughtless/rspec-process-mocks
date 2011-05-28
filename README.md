WARNING: This is just a big hack right now. If you are interested in using this
project but I haven't removed this warning yet, please bug me to lessen the
hackiness and make it more usable.


# RSpec Process Mocks

rspec-process-mocks is an addon to rspec-mocks that provides support
for method stubs, fakes, and message expectations within child processes.

## Documentation

## Setup ##

Gemfile
  gem 'rspec-process-mocks', :git => 'git://github.com/thoughtless/rspec-process-mocks.git'

`bundle install`

spec/spec_helper.rb
  require 'rspec/process_mocks' # This line must be after 'config.mock_with :rspec'

## Message Expectations

    describe "some action" do
      context "when bad stuff happens" do
        it "logs the error" do
          logger = double('logger')
          doer = Doer.new(logger)
          logger.should_receive_in_child_process(:log)
          doer.do_something_with(:bad_data)
          sleep 0.1 # Leave time for the child process to run.
        end
      end
    end

    class Doer
      attr_accessor :logger
      def do_something_with(data)
        Process.fork { logger.log(data) }
      end
    end

## Contribute

See [http://github.com/thoughtless/rspec-process-mocks](http://github.com/thoughtless/rspec-process-mocks)

## Also see

* [http://github.com/rspec/rspec](http://github.com/rspec/rspec)
* [http://github.com/rspec/rspec-core](http://github.com/rspec/rspec-core)
* [http://github.com/rspec/rspec-expectations](http://github.com/rspec/rspec-expectations)
