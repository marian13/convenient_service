# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class PrependModule
          ##
          # @param mod [Module]
          #
          # @internal
          #   NOTE: `mod` since `module` is a keyword.
          #
          def initialize(mod)
            @mod = mod
          end

          ##
          # @param klass [Class, Module]
          # @return [Boolean]
          #
          # @internal
          #   TODO: Util `prepend_module?`.
          #
          def matches?(klass)
            @klass = klass

            klass.ancestors.take_while { |ancestor| ancestor != klass }.include?(mod)
          end

          ##
          # @return [String]
          #
          def description
            "prepend module `#{mod}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass}` to prepend module `#{mod}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{klass}` NOT to prepend module `#{mod}`"
          end

          private

          ##
          # @!attribute [r] klass
          #   @return [Class, Module]
          #
          attr_reader :klass

          ##
          # @!attribute [r] mod
          #   @return [Module]
          #
          attr_reader :mod
        end
      end
    end
  end
end
