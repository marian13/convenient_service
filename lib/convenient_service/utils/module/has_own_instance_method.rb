# frozen_string_literal: true

module ConvenientService
  module Utils
    module Module
      class HasOwnInstanceMethod < Support::Command
        ##
        # @!attribute [r] mod
        #   @return [Class, Module]
        #
        attr_reader :mod

        ##
        # @!attribute [r] method
        #   @return [String, Symbol]
        #
        attr_reader :method

        ##
        # @!attribute [r] private
        #   @return [Boolean]
        #
        attr_reader :private

        ##
        # @param [Class, Module]
        # @param [String, Symbol]
        # @return [void]
        #
        def initialize(mod, method, private: false)
          @mod = mod
          @method = method
          @private = private
        end

        ##
        # @return [Boolean]
        #
        def call
          method_name = method.to_sym

          return true if own_instance_methods.include?(method_name)

          if private
            return true if private_own_instance_methods.include?(method_name)
          end

          false
        end

        private

        ##
        # @return [Array<Symbol>]
        #
        # @internal
        #   NOTE: `instance_methods` returns both public and protected methods.
        #   NOTE: `instance_methods(false)` returns only own methods.
        #
        def own_instance_methods
          @own_instance_methods ||= mod.instance_methods(false)
        end

        ##
        # @return [Array<Symbol>]
        #
        # @internal
        #   NOTE: `private_instance_methods(false)` returns only own methods.
        #
        def private_own_instance_methods
          @private_own_instance_methods ||= mod.private_instance_methods(false)
        end
      end
    end
  end
end
