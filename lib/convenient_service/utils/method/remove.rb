# frozen_string_literal: true

module ConvenientService
  module Utils
    module Method
      class Remove < Support::Command
        ##
        # @!attribute [r] method
        #   @return [String, Symbol]
        #
        attr_reader :method

        ##
        # @!attribute [r] klass
        #   @return [Class]
        #
        attr_reader :klass

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
        # @param method [Symbol, String]
        # @param klass [Class]
        # @param public [Boolean]
        # @param protected [Boolean]
        # @param private [Boolean]
        # @return [void]
        #
        # @internal
        #   NOTE: `protected` is set to `true` by default to keep a similar behaviour to `Module#method_defined?`.
        #   - https://ruby-doc.org/core-3.1.0/Module.html#method-i-method_defined-3F
        #
        def initialize(method, klass, public: true, protected: true, private: false)
          @method = method.to_s
          @klass = klass
          @public = public
          @protected = protected
          @private = private
        end

        ##
        # @return [Class]
        #
        # @internal
        #   NOTE: Returns `klass` to keep a similar behaviour to `Module#remove_method`.
        #   - https://ruby-doc.org/core-2.7.1/Module.html#method-i-remove_method
        #
        def call
          return unless Utils::Method.defined?(method, klass, public: public, protected: protected, private: private)

          klass.remove_method method
        end
      end
    end
  end
end
