require 'tempfile'

module RSpec
  module ProcessMocks
    class ChildProcessMessageExpectation < RSpec::Mocks::MessageExpectation
      def initialize(*args)
        super

        # The temp files are used for interprocess communication.
        # This one stores the calls that are exact matches.
        @actual_tempfile = Tempfile.new("should-receive-#{@expected_from.object_id}-#{@sym}")
        # This one stores the similar calls.
        @similar_tempfile = Tempfile.new("should-receive-similar-#{@expected_from.object_id}-#{@sym}")
      end


      # This method is executed in the _child_ process when the stubbed method
      # is called exact arguments
      # Overwritten from rspec.
      def invoke(*args, &block)
        msg = args.inspect
        @actual_tempfile.puts msg
        @actual_tempfile.flush
      end

      # This method is executed in the _child_ process when the stubbed method
      # is called with similar argument.
      # Overwritten from rspec.
      def advise(*args)
        @similar_tempfile.puts msg
        @similar_tempfile.flush
        similar_messages
      end

      # This overwrites the rspec implementation because we need to record
      # similar messages in a temp file not instance variables.
      def similar_messages
        @similar_tempfile.rewind
        @similar_tempfile.readlines
      end

      # Reads back the actual/exact-match arguments written to the temp file.
      # This is not a method in rspec.
      def actual_messages
        @actual_tempfile.rewind
        @actual_tempfile.readlines
      end

      # The following methods used to use instance variables. But we can't do
      # that because those aren't shared between processes. These methods
      # overwrite rspec's behavior and instead keep the state in temp files.
      def actual_received_count
        actual_messages.size
      end
      def generate_error
        if similar_messages.empty?
          @error_generator.raise_expectation_error(@sym, @expected_received_count, actual_received_count, *@args_expectation.args)
        else
          @error_generator.raise_similar_message_args_error(self, *similar_messages)
        end
      end
      def matches_at_least_count?
        @at_least && actual_received_count >= @expected_received_count
      end
      def matches_at_most_count?
        @at_most && actual_received_count <= @expected_received_count
      end
      def matches_exact_count?
        @expected_received_count == actual_received_count
      end
    end
  end
end
