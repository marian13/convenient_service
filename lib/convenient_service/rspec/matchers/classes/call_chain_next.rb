# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        ##
        # @example Common usage.
        #   expect { method.call }
        #     .to call_chain_next.on(method)
        #     .with_arguments(*args, **kwargs, &block)
        #     .and_return_its_value
        #
        # @internal
        #   TODO:
        #     expect { method.call }
        #       .to call_chain_next.on(method)
        #       .with_arguments(*args, **kwargs, &block)
        #       .and_return { |chain_value| chain_value.copy(kwargs: {overrides: {foo: :bar}})}
        #
        class CallChainNext
          include ::RSpec::Expectations
          include ::RSpec::Matchers
          include ::RSpec::Mocks::ExampleMethods

          ##
          # @param block_expectation [Proc, nil]
          # @return [Bool]
          # @raise [RSpec::Expectations::ExpectationNotMetError]
          #
          # @internal
          #   NOTE: Using `expect` inside custom matchers is NOT a good idea, since failure descriptions are too generic and may mislead the end-user.
          #   TODO: Refactor to return only boolean, without raises.
          #
          #   NOTE: RSpec is using exception for control flow.
          #   - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/expectations.rb
          #
          def matches?(block_expectation)
            @block_expectation = block_expectation

            value = nil

            expect { value = block_expectation.call }.to change(method, :chain_called?).from(false).to(true)

            if used_with_arguments?
              ##
              # NOTE: When `comparison_method` is `:==`.
              #
              # expect(expected_args == method.chain_args).to eq(true)
              # expect(expected_kwargs == method.chain_kwargs).to eq(true)
              # expect(expected_block == method.chain_block).to eq(true)
              #
              # NOTE: When `comparison_method` is `:===`.
              #
              # expect(expected_args === method.chain_args).to eq(true)
              # expect(expected_kwargs === method.chain_kwargs).to eq(true)
              # expect(expected_block === method.chain_block).to eq(true)
              #
              expect(expected_args.public_send(comparison_method, method.chain_args)).to eq(true)
              expect(expected_kwargs.public_send(comparison_method, method.chain_kwargs)).to eq(true)
              expect(expected_block.public_send(comparison_method, method.chain_block)).to eq(true)
            end

            if used_and_return_its_value?
              ##
              # NOTE: When `comparison_method` is `:==`.
              #
              # expect(method.chain_value == value).to eq(true)
              #
              # NOTE: When `comparison_method` is `:===`.
              #
              # expect(method.chain_value === value).to eq(true)
              #
              expect(method.chain_value.public_send(comparison_method, value)).to eq(true)
            end

            if used_and_return?
              ##
              # NOTE: When `comparison_method` is `:==`.
              #
              # expect(return_block.call(method.chain_value) == value).to eq(true)
              #
              # NOTE: When `comparison_method` is `:===`.
              #
              # expect(return_block.call(method.chain_value) === value).to eq(true)
              #
              expect(return_block.call(method.chain_value).public_send(comparison_method, value)).to eq(true)
            end

            true
          end

          ##
          # @param block_expectation [Proc, nil]
          # @return [Bool]
          # @raise [RSpec::Expectations::ExpectationNotMetError]
          #
          # @internal
          #   NOTE: Using `expect` inside custom matchers is NOT a good idea, since failure descriptions are too generic and may mislead the end-user.
          #   TODO: Refactor to return only boolean, without raises.
          #
          #   NOTE: RSpec is using exception for control flow.
          #   - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/expectations.rb
          #
          def does_not_match?(block_expectation)
            @block_expectation = block_expectation

            value = nil

            ##
            # NOTE: `expect { value = block_expectation.call }.not_to change(method, :chain_called?).from(false).to(true)` raises the following error:
            #
            #   NotImplementedError:
            #     `expect { }.not_to change { }.to()` is not supported
            #
            # That is why `expect(method.chain_called?).to eq(false)` is introduced.
            # - https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/matchers/built_in/change.rb#L50
            #
            expect(method.chain_called?).to eq(false)

            expect { value = block_expectation.call }.not_to change(method, :chain_called?)

            if used_with_arguments?
              expect(method.chain_args).not_to eq(expected_args)
              expect(method.chain_kwargs).not_to eq(expected_kwargs)
              expect(method.chain_block).not_to eq(expected_block)
            end

            if used_and_return_its_value?
              expect(value).not_to eq(method.chain_value)
            end

            if used_and_return?
              expect(value).not_to eq(return_block.call(method.chain_value))
            end

            true
          end

          ##
          # @return [Boolean]
          #
          def supports_block_expectations?
            true
          end

          ##
          # @return [String]
          #
          def description
            "call `chain.next`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected to call `chain.next`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected NOT to call `chain.next`"
          end

          ##
          # @param method [ConvenientService::RSpec::Helpers::Classes::Entities::WrappedMethod]
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def on(method)
            method.reset!

            chain[:method] = method

            self
          end

          ##
          # @param args[Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def with_arguments(*args, **kwargs, &block)
            chain[:with_arguments] = {args: args, kwargs: kwargs, block: block}

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def with_any_arguments
            chain.delete(:with_arguments)

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def without_arguments
            chain[:with_arguments] = {args: [], kwargs: {}, block: nil}

            self
          end

          ##
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def and_return_its_value
            chain[:and_return_its_value] = true

            self
          end

          ##
          # @param value[Object, ConvenientService::Support::NOT_PASSED]
          # @param block [Proc, nil]
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def and_return(*args, &block)
            chain[:and_return] = args.any? ? proc { args.first } : block

            self
          end

          ##
          # @param comparison_method [String, Symbol]
          #
          # @return [ConvenientService::RSpec::Matchers::Classes::CallChainNext]
          #
          def comparing_by(comparison_method)
            chain[:comparing_by] = comparison_method

            self
          end

          private

          ##
          # @!attribute [r] block_expectation
          #   @return [Proc, nil]
          #
          attr_reader :block_expectation

          ##
          # @return [Boolean]
          #
          def used_with_arguments?
            chain.key?(:with_arguments)
          end

          ##
          # @return [Boolean]
          #
          def used_and_return_its_value?
            chain.key?(:and_return_its_value)
          end

          ##
          # @return [Boolean]
          #
          def used_and_return?
            chain.key?(:and_return)
          end

          ##
          # @return [Boolean]
          #
          def used_comparing_by?
            chain.key?(:comparing_by)
          end

          ##
          # @return [Hash{Symbol => Object}]
          #
          def chain
            @chain ||= {}
          end

          ##
          # @return [ConvenientService::RSpec::Helpers::Classes::Entities::WrappedMethod]
          #
          def method
            @method ||= chain[:method]
          end

          ##
          # @return [Array<Object>]
          #
          def args
            @args ||= chain.dig(:with_arguments, :args) || []
          end

          ##
          # @return [Array<Object>]
          #
          alias_method :expected_args, :args

          ##
          # @return [Hash{Symbol => Object}]
          #
          def kwargs
            @kwargs ||= chain.dig(:with_arguments, :kwargs) || {}
          end

          ##
          # @return [Hash{Symbol => Object}]
          #
          alias_method :expected_kwargs, :kwargs

          ##
          # @return [Proc, nil]
          #
          # @internal
          #   NOTE: `if defined?` is used in order to cache `nil` if needed.
          #
          def block
            return @block if defined? @block

            @block = chain.dig(:with_arguments, :block)
          end

          ##
          # @return [Proc, nil]
          #
          alias_method :expected_block, :block

          ##
          # @return [Proc]
          #
          def return_block
            @return_block ||= chain[:and_return]
          end

          ##
          # @return [String, Symbol]
          #
          def comparison_method
            @comparison_method ||= chain[:comparing_by] || :==
          end
        end
      end
    end
  end
end
