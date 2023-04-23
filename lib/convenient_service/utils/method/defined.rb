# frozen_string_literal: true

module ConvenientService
  module Utils
    module Method
      class Defined < Support::Command
        METHOD_DEFINED_CHECKERS = {
          public: ->(klass, method) { klass.public_method_defined?(method) },
          protected: ->(klass, method) { klass.protected_method_defined?(method) },
          private: ->(klass, method) { klass.private_method_defined?(method) }
        }

        ##
        # @!attribute [r] method
        #   @return [Class]
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
        #   NOTE: `protected` is set to `true` by default to keep the same semantics as `Module#method_defined?`.
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
        # @return [void]
        #
        def call
          return false if selected_visibilities.none?

          selected_visibilities.any? { |visibility| method_defined?(visibility) }
        end

        ##
        # @return [Array<Symbol>]
        #
        # @internal
        #   NOTE: `keep_if` seems more readable than `select` (just a personal feeling).
        #   It is safe to use `keep_if` since a new hash is created. Prefer `select` in a general case, since it is NOT mutable.
        #
        def selected_visibilities
          @selected_visibilities ||= {public: public, protected: protected, private: private}.keep_if { |_, should_be_checked| should_be_checked }.keys
        end

        ##
        # @param visibility [Symbol]
        # @return [Boolean]
        #
        def method_defined?(visibility)
          METHOD_DEFINED_CHECKERS[visibility].call(klass, method)
        end
      end
    end
  end
end
