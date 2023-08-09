# frozen_string_literal: true

require_relative "ignoring_error/exceptions"

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class IgnoringError < Support::Command
          ##
          # @!attribute [r] error
          #   @return [StandardError]
          #
          attr_reader :error

          ##
          # @!attribute [r] block
          #   @return [Proc]
          #
          attr_reader :block

          ##
          # @param error [StandardError]
          # @param block [Proc]
          #
          def initialize(error, &block)
            @error = error
            @block = block
          end

          ##
          # @return [ConvenientService::Support::UniqueValue]
          # @raise [ConvenientService::RSpec::Helpers::Custom::IgnoringError::Exceptions::IgnoredErrorIsNotRaised]
          #
          # @note Rescue `StandardError`, NOT `Exception`.
          # @see https://thoughtbot.com/blog/rescue-standarderror-not-exception
          # @see https://ruby-doc.org/core-2.7.0/StandardError.html
          # @see https://ruby-doc.org/core-2.7.0/Exception.html
          #
          def call
            block.call
          rescue *error
            Support::UNDEFINED
          else
            raise Exceptions::IgnoredErrorIsNotRaised.new(error: error)
          end
        end
      end
    end
  end
end
