# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        ##
        # @internal
        #   class User
        #     include InstanceMethods
        #
        #     singleton_class.include ClassMethods # or more common `extend ClassMethods`.
        #
        #     prepend InstanceMethods
        #
        #     singleton_class.prepend ClassMethods # no short form like `extend`.
        #   end
        #
        class SingletonPrependModule
          ##
          # @param mod [Module]
          # @return [void]
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
          def matches?(klass)
            @klass = klass

            klass.singleton_class.ancestors.take_while { |ancestor| ancestor != klass }.include?(mod)
          end

          ##
          # @return [String]
          #
          def description
            "`singleton_class.prepend` module `#{mod}`"
          end

          ##
          # @return [String]
          #
          def failure_message
            "expected `#{klass}` to `singleton_class.prepend` module `#{mod}`"
          end

          ##
          # @return [String]
          #
          def failure_message_when_negated
            "expected `#{klass}` NOT to `singleton_class.prepend` module `#{mod}`"
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
