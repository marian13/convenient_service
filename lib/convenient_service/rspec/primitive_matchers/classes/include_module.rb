# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class IncludeModule
          ##
          # NOTE: `mod` since `module` is a keyword.
          #
          def initialize(mod)
            @mod = mod
          end

          def matches?(klass)
            @klass = klass

            klass.included_modules.include?(mod)
          end

          def description
            "include module `#{mod}`"
          end

          def failure_message
            "expected `#{klass}` to include module `#{mod}`"
          end

          def failure_message_when_negated
            "expected `#{klass}` NOT to include module `#{mod}`"
          end

          private

          attr_reader :klass, :mod
        end
      end
    end
  end
end
