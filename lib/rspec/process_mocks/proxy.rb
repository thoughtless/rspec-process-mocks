module RSpec
  module ProcessMocks
    module Proxy
      def add_child_process_message_expectation(location, method_name, opts={}, &block)
        method_double[method_name].add_child_process_expectation @error_generator, @expectation_ordering, location, opts, &block
      end
    end
  end
end

module RSpec
  module Mocks
    class Proxy
      include RSpec::ProcessMocks::Proxy
    end
  end
end
