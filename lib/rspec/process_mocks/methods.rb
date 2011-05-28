module RSpec
  module ProcessMocks
    module Methods
      def should_receive_in_child_process(sym, opts={}, &block)
        __mock_proxy.add_child_process_message_expectation(opts[:expected_from] || caller(1)[0], sym.to_sym, opts, &block)
      end
    end
  end
end

module RSpec
  module Mocks
    module Methods
      include RSpec::ProcessMocks::Methods
    end
  end
end
