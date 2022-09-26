# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        ##
        #   expect { method.call }
        #     .to call_chain_next.on(method)
        #     .with_arguments(*args, **kwargs, &block)
        #     .and_return_its_value
        #
        class CallChainNext
          include ::RSpec::Expectations
          include ::RSpec::Matchers
          include ::RSpec::Mocks::ExampleMethods

          def matches?(block_expectation)
            @block_expectation = block_expectation

            value = nil

            expect { value = block_expectation.call }.to change(method, :chain_called?).from(false).to(true)

            if used_with_arguments?
              expect(method.chain_args).to eq(expected_args)
              expect(method.chain_kwargs).to eq(expected_kwargs)
              expect(method.chain_block).to eq(expected_block)
            end

            if used_and_return_its_value?
              expect(value).to eq(method.chain_value)
            end

            true
          end

          ##
          # https://github.com/rspec/rspec-expectations/blob/main/lib/rspec/matchers/built_in/change.rb#L50
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

            true
          end

          def supports_block_expectations?
            true
          end

          def description
            "call `chain.next`"
          end

          def failure_message
            "expected to call `chain.next`"
          end

          def failure_message_when_negated
            "expected NOT to call `chain.next`"
          end

          def on(method)
            chain[:method] = method

            self
          end

          def with_arguments(*args, **kwargs, &block)
            chain[:with_arguments] = {args: args, kwargs: kwargs, block: block}

            self
          end

          def and_return_its_value
            chain[:and_return_its_value] = true

            self
          end

          private

          attr_reader :block_expectation

          def used_with_arguments?
            chain.key?(:with_arguments)
          end

          def used_and_return_its_value?
            chain.key?(:and_return_its_value)
          end

          def chain
            @chain ||= {}
          end

          def method
            @method ||= chain[:method]
          end

          def args
            @args ||= chain.dig(:with_arguments, :args) || []
          end

          alias_method :expected_args, :args

          def kwargs
            @kwargs ||= chain.dig(:with_arguments, :kwargs) || {}
          end

          alias_method :expected_kwargs, :kwargs

          ##
          # NOTE: `if defined?` is used in order to cache `nil` if needed.
          #
          def block
            return @block if defined? @block

            @block = chain.dig(:with_arguments, :block)
          end

          alias_method :expected_block, :block
        end
      end
    end
  end
end
