# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "ignoring_exception/exceptions"

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class IgnoringException < Support::Command
          ##
          # @!attribute [r] exception
          #   @return [StandardError]
          #
          attr_reader :exception

          ##
          # @!attribute [r] block
          #   @return [Proc]
          #
          attr_reader :block

          ##
          # @param exception [StandardError]
          # @param block [Proc]
          #
          def initialize(exception, &block)
            @exception = exception
            @block = block
          end

          ##
          # @return [ConvenientService::Support::UniqueValue]
          # @raise [ConvenientService::RSpec::Helpers::Classes::IgnoringException::Exceptions::IgnoredExceptionIsNotRaised]
          #
          # @note Rescue `StandardError`, NOT `Exception`.
          # @see https://thoughtbot.com/blog/rescue-standarderror-not-exception
          # @see https://ruby-doc.org/core-2.7.0/StandardError.html
          # @see https://ruby-doc.org/core-2.7.0/Exception.html
          #
          def call
            block.call
          rescue exception
            Support::UNDEFINED
          else
            ::ConvenientService.raise Exceptions::IgnoredExceptionIsNotRaised.new(exception: exception)
          end
        end
      end
    end
  end
end
