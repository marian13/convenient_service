# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class PrependModule
          ##
          # NOTE: `mod' since `module' is a keyword.
          #
          def initialize(mod)
            @mod = mod
          end

          def matches?(klass)
            @klass = klass

            klass.ancestors.take_while { |ancestor| ancestor != klass }.include?(mod)
          end

          def description
            "prepend module `#{mod}'"
          end

          def failure_message
            "expected `#{klass}' to prepend module `#{mod}'"
          end

          def failure_message_when_negated
            "expected `#{klass}' NOT to prepend module `#{mod}'"
          end

          private

          attr_reader :klass, :mod
        end
      end
    end
  end
end
