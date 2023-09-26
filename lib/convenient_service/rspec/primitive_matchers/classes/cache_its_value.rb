# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class CacheItsValue
          ##
          # @note `cache_its_value` may lead to false positives.
          # @note `cache_its_value` calls the `expect` block twice to check its return values object ids.
          #
          # @example False positive spec.
          #
          #   let(:command_result) { command.call }
          #
          #   specify do
          #     # bad - `command_result` is already cached(memoized) by `let`. That is why `cache_its_value` is always satisfied.
          #     expect { command_result }.to cache_its_value
          #   end
          #
          # @example Correct spec.
          #
          #   specify do
          #     # good - `command.call` is recalculated every time `expect` block is invoked.
          #     expect { command.call }.to cache_its_value
          #   end
          #
          def matches?(block_expectation)
            @block_expectation = block_expectation

            ##
            # NOTE: Identical to `block_expectation.call.object_id == block_expectation.call.object_id`.
            #
            block_expectation.call.equal?(block_expectation.call)
          end

          def supports_block_expectations?
            true
          end

          def description
            "cache its value"
          end

          def failure_message
            "expected #{printable_block_expectation} to cache its value"
          end

          def failure_message_when_negated
            "expected #{printable_block_expectation} NOT to cache its value"
          end

          ##
          # NOTE: An example of how RSpec extracts block source, but they marked it as private.
          # https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
          #
          # TODO: `printable_block_expectation` when `method_source` is available.
          # https://github.com/banister/method_source
          #
          # def printable_block_expectation
          #   @printable_block_expectation ||= block_expectation.source
          # end
          #
          def printable_block_expectation
            @printable_block_expectation ||= "{ ... }"
          end

          private

          attr_reader :block_expectation
        end
      end
    end
  end
end
