# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class CacheItsValue
          def matches?(block_expectation)
            @block_expectation = block_expectation

            ##
            # NOTE: Identical to `block_expectation.call.object_id == block_expectation.call.object_id'.
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

          def printable_block
            @printable_block ||= block_expectation.source
          end

          private

          attr_reader :block_expectation
        end
      end
    end
  end
end
