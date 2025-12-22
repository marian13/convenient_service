# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class IncludeConfig
          ##
          # @param config [Module]
          #
          def initialize(config)
            @config = config
          end

          ##
          # @param klass [Class]
          # @return [Boolean]
          #
          # @internal
          #   TODO: Util `include_module?`.
          #
          #   NOTE: `any?(arg)` compares with `===`. For this method `==` is mandatory.
          #
          # rubocop:disable Performance/RedundantEqualityComparisonBlock
          def matches?(klass)
            @klass = klass

            klass.ancestors.drop_while { |ancestor| ancestor != klass }.any? { |mod| config == mod }
          end
          # rubocop:enable Performance/RedundantEqualityComparisonBlock

          ##
          # @return [String]
          #
          def description
            "include config `#{config.inspect}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass.inspect}` to include config `#{config.inspect}`"
          end

          ##
          # @return [String]

          def failure_message_when_negated
            "expected `#{klass.inspect}` NOT to include config `#{config.inspect}`"
          end

          private

          ##
          # @!attribute [r] klass
          #   @return [Class]
          #
          attr_reader :klass

          ##
          # @!attribute [r] config
          #   @return [Module]
          #
          attr_reader :config
        end
      end
    end
  end
end
