# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class CacheItsValue
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
            "expected #{printable_block} to cache its value"
          end

          def failure_message_when_negated
            "expected #{printable_block} NOT to cache its value"
          end

          ##
          # NOTE: An example of how RSpec extracts block source, but they marked it as private.
          # https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
          #
          # TODO: `printable_block` when `method_source` is available.
          # https://github.com/banister/method_source
          #
          # def printable_block
          #   @printable_block ||= block_expectation.source
          # end
          #
          def printable_block
            @printable_block ||= "{ ... }"
          end

          private

          attr_reader :block_expectation
        end
      end
    end
  end
end
