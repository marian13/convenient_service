# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class IncludeInOrder
          ##
          # @param keywords [Array<String, Regexp>]
          # @return [void]
          #
          def initialize(keywords)
            @keywords = keywords
          end

          ##
          # @param string [String]
          # @return [Boolean]
          #
          # @internal
          #   NOTE: Implementation is very basic just to serve the need of this library.
          #
          def matches?(string)
            @string = string

            return false if keywords.empty?

            scanner = ::StringScanner.new(string)

            keywords.all? { |keyword| scanner.scan_until(keyword) }
          end

          ##
          # @return [String]
          #
          def description
            "include in order #{printable_keywords}"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{string.inspect}` include in order #{printable_keywords}"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{string.inspect}` NOT include in order #{printable_keywords}"
          end

          private

          ##
          # @!attribute [r] string
          #   @return [String]
          #
          attr_reader :string

          ##
          # @!attribute [r] keywords
          #   @return [Array<String, Regexp>]
          #
          attr_reader :keywords

          ##
          # @return [String]
          #
          def printable_keywords
            keywords.map(&:inspect).join(", ")
          end
        end
      end
    end
  end
end
