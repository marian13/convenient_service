# frozen_string_literal: true

module ConvenientService
  module Utils
    module Proc
      class Display < Support::Command
        ##
        # @!attribute [r] proc
        #   @return [Proc]
        #
        attr_reader :proc

        ##
        # @param proc [Proc]
        # @return [void]
        #
        def initialize(proc)
          @proc = proc
        end

        ##
        # @return [Object] Can be any type.
        #
        # @internal
        #   NOTE: An example of how RSpec extracts block source, but they marked it as private.
        #   https://github.com/rspec/rspec-expectations/blob/311aaf245f2c5493572bf683b8c441cb5f7e44c8/lib/rspec/matchers/built_in/change.rb#L437
        #
        #   TODO: `printable_block_expectation` when `method_source` is available.
        #   https://github.com/banister/method_source
        #
        #   def printable_block_expectation
        #     @printable_block_expectation ||= block_expectation.source
        #   end
        #
        #   TODO: Generic util to print blocks.
        #
        def call
          "{ ... }"
        end
      end
    end
  end
end
