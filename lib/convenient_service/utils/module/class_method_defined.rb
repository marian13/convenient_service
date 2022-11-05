# frozen_string_literal: true

module ConvenientService
  module Utils
    module Module
      class ClassMethodDefined < Support::Command
        ##
        # @!attribute [r] mod
        #   @return [Class, Module]
        #
        attr_reader :mod

        ##
        # @!attribute [r] method_name
        #   @return [String, Symbol]
        #
        attr_reader :method_name

        ##
        # @!attribute [r] private
        #   @return [Boolean]
        #
        attr_reader :private

        ##
        # @param mod [Class, Module]
        # @param method_name [String, Symbol]
        # @param private [Boolean]
        # @return [void]
        #
        def initialize(mod, method_name, private: false)
          @mod = mod
          @method_name = method_name
          @private = private
        end

        ##
        # @return [Boolean]
        #
        def call
          Utils::Method.defined?(method_name, mod.singleton_class, private: true)
        end
      end
    end
  end
end
