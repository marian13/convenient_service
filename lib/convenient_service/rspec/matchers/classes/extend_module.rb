# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        class ExtendModule
          ##
          # NOTE: `mod` since `module` is a keyword.
          #
          def initialize(mod)
            @mod = mod
          end

          def matches?(klass)
            @klass = klass

            klass.singleton_class.included_modules.include?(mod)
          end

          def description
            "extend module `#{mod}`"
          end

          def failure_message
            "expected `#{klass}` to extend module `#{mod}`"
          end

          def failure_message_when_negated
            "expected `#{klass}` NOT to extend module `#{mod}`"
          end

          private

          attr_reader :klass, :mod
        end
      end
    end
  end
end
