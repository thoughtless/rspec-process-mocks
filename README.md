# RSpec Process Mocks

rspec-process-mocks is an addon to rspec-mocks that provides support
for method stubs, fakes, and message expectations within child processes.

## Documentation

## Message Expectations

    describe "some action" do
      context "when bad stuff happens" do
        it "logs the error" do
          logger = double('logger')
          doer = Doer.new(logger)
          logger.should_receive_in_child_process(:log)
          doer.do_something_with(:bad_data)
        end
      end
    end

## Contribute

See [http://github.com/thoughtless/rspec-process-mocks](http://github.com/thoughtless/rspec-process-mocks)

## Also see

* [http://github.com/rspec/rspec](http://github.com/rspec/rspec)
* [http://github.com/rspec/rspec-core](http://github.com/rspec/rspec-core)
* [http://github.com/rspec/rspec-expectations](http://github.com/rspec/rspec-expectations)
