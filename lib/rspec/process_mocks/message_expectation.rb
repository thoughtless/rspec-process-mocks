module RSpec
  module ProcessMocks
    class ChildProcessMessageExpectation < RSpec::Mocks::MessageExpectation
      def initialize(*args)
        super

        # The tempfile is used for interprocess communication
        @tempfile = Tempfile.new("should-receive-#{@expected_from.object_id}-#{@sym}")
      end
      def verify_messages_received

        @tempfile.rewind
        lines = @tempfile.readlines
#puts "lines in verify_messages_received: #{lines.inspect}"
        return true if lines.size == 1 #&& # Called exactly once.
#          lines[0] == "[]\n" # Called with no arguments.

        generate_error
      rescue RSpec::Mocks::MockExpectationError => error
        error.backtrace.insert(0, @expected_from)
        Kernel::raise error
      end

      def matches_exact_count?
        lines.size == 1
      end

      # This method is executed in the _child_ process when the stubbed method
      # is called.
      def invoke(*args, &block)

        msg = args.inspect
        @tempfile.puts msg
        @tempfile.flush
#        puts "##{@sym} called on #{@expected_from.class}-#{@expected_from.object_id}; args: #{args.inspect}"
#        yield block, *args if defined?(block)
      end

      def similar_messages
        []
      end
    end
  end
end
