module RSpec
  module ProcessMocks
    module MethodDouble
      def add_child_process_expectation(error_generator, expectation_ordering, expected_from, opts, &block)
        configure_method
#        expectation = if existing_stub = stubs.first
#          existing_stub.build_child(expected_from, block, 1, opts)
#        else
#          ChildProcessMessageExpectation.new(error_generator, expectation_ordering, expected_from, @method_name, block, 1, opts)
#        end
#        expectations << expectation
        expectation = ChildProcessMessageExpectation.new(error_generator, expectation_ordering, expected_from, @method_name, block, 1, opts)
        expectations << expectation
        expectation
      end
    end
  end
end

module RSpec
  module Mocks
    class MethodDouble
      include RSpec::ProcessMocks::MethodDouble
    end
  end
end
