Feature: expect a message

  Use should_receive() to set an expectation that a receiver should receive a
  message before the example is completed.

  Scenario: expect a message
    Given a file named "spec/account_spec.rb" with:
      """
      RSpec.configuration.mock_framework = :rspec
      $: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
      require 'rspec/process_mocks'
      require "account"

      describe Account do
        context "when closed" do
          it "logs an account closed message in a child process" do

            logger = double("logger")
            account = Account.new
            account.logger = logger

            logger.should_receive_in_child_process(:account_closed)

            account.close

            sleep 0.1
          end
        end
      end
      """
    And a file named "lib/account.rb" with:
      """
      class Account
        attr_accessor :logger

        def close
          Process.fork { logger.account_closed }
        end
      end
      """
    When I run `rspec spec/account_spec.rb`
    Then the output should contain "1 example, 0 failures"

  Scenario: expect a message, but it isn't called
    Given a file named "spec/account_spec.rb" with:
      """
      RSpec.configuration.mock_framework = :rspec
      $: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
      require 'rspec/process_mocks'
      require "account"

      describe Account do
        context "when closed" do
          it "logs an account closed message in a child process" do

            logger = double("logger")
            account = Account.new
            account.logger = logger

            logger.should_receive_in_child_process(:account_closed)

            account.close

            sleep 0.1
          end
        end
      end
      """
    And a file named "lib/account.rb" with:
      """
      class Account
        attr_accessor :logger

        def close
          Process.fork { logger.object_id }
        end
      end
      """
    When I run `rspec spec/account_spec.rb`
    Then the output should contain "1 example, 1 failure"
    And the output should contain "expected: 1 time"
    And the output should contain "received: 0 times"

  Scenario: expect a message, and it is called twice
    Given a file named "spec/account_spec.rb" with:
      """
      RSpec.configuration.mock_framework = :rspec
      $: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
      require 'rspec/process_mocks'
      require "account"

      describe Account do
        context "when closed" do
          it "logs an account closed message in a child process" do

            logger = double("logger")
            account = Account.new
            account.logger = logger

            logger.should_receive_in_child_process(:account_closed)

            account.close

            sleep 0.1
          end
        end
      end
      """
    And a file named "lib/account.rb" with:
      """
      class Account
        attr_accessor :logger

        def close
          Process.fork do
            logger.account_closed
            logger.account_closed
          end
        end
      end
      """
    When I run `rspec spec/account_spec.rb`
    Then the output should contain "1 example, 1 failure"
    And the output should contain "expected: 1 time"
    And the output should contain "received: 2 times"

  Scenario: expect a message at least once, and it is called twice
    Given a file named "spec/account_spec.rb" with:
      """
      RSpec.configuration.mock_framework = :rspec
      $: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
      require 'rspec/process_mocks'
      require "account"

      describe Account do
        context "when closed" do
          it "logs an account closed message in a child process" do

            logger = double("logger")
            account = Account.new
            account.logger = logger

            logger.should_receive_in_child_process(:account_closed).at_least(1).times

            account.close

            sleep 0.1
          end
        end
      end
      """
    And a file named "lib/account.rb" with:
      """
      class Account
        attr_accessor :logger

        def close
          Process.fork do
            logger.account_closed
            logger.account_closed
          end
        end
      end
      """
    When I run `rspec spec/account_spec.rb`
    Then the output should contain "1 example, 0 failure"

  @wip
  Scenario: expect a message with an argument
    Given a file named "spec/account_spec.rb" with:
      """
      RSpec.configuration.mock_framework = :rspec
      $: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
      require 'rspec/process_mocks'
      require "account"

      describe Account do
        context "when closed" do
          it "logs an account closed message" do
            logger = double("logger")
            account = Account.new
            account.logger = logger

            logger.should_receive_in_child_process(:account_closed).with(account)

            account.close

            puts 'start sleep'
            sleep 1
            puts 'end sleep'

            account.logger
          end
        end
      end
      """
    And a file named "lib/account.rb" with:
      """
      class Account
        attr_accessor :logger

        def close
          Process.fork { logger.account_closed(self) }
        end
      end
      """
    When I run `rspec spec/account_spec.rb`
    Then the output should contain "1 example, 0 failures"

  @wip
  Scenario: provide a return value
    Given a file named "message_expectation_spec.rb" with:
      """
      RSpec.configuration.mock_framework = :rspec
      $: << File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
      require 'rspec/process_mocks'
      describe "a message expectation" do
        context "with a return value" do
          context "specified in a block" do
            it "returns the specified value" do
              receiver = double("receiver")
              receiver.should_receive_in_child_process(:message) { :return_value }
              receiver.message.should eq(:return_value)
            end
          end

          context "specified with and_return" do
            it "returns the specified value" do
              receiver = double("receiver")
              receiver.should_receive_in_child_process(:message).and_return(:return_value)
              receiver.message.should eq(:return_value)
            end
          end
        end
      end
      """
    When I run `rspec message_expectation_spec.rb`
    Then the output should contain "2 examples, 0 failures"
