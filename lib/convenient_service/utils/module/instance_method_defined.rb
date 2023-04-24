# frozen_string_literal: true

module ConvenientService
  module Utils
    module Module
      class InstanceMethodDefined < Support::Command
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
        # @!attribute [r] public
        #   @return [Boolean]
        #
        attr_reader :public

        ##
        # @!attribute [r] protected
        #   @return [Boolean]
        #
        attr_reader :protected

        ##
        # @!attribute [r] private
        #   @return [Boolean]
        #
        attr_reader :private

        ##
        # @param mod [Class, Module]
        # @param method_name [String, Symbol]
        # @param public [Boolean]
        # @param protected [Boolean]
        # @param private [Boolean]
        # @return [void]
        #
        def initialize(mod, method_name, public: true, protected: true, private: false)
          @mod = mod
          @method_name = method_name
          @public = public
          @protected = protected
          @private = private
        end

        ##
        # @return [Boolean]
        #
        def call
          Utils::Method.defined?(method_name, mod, public: public, protected: protected, private: private)
        end
      end
    end
  end
end
