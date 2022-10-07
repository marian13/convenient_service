# frozen_string_literal: true

module ConvenientService
  module Utils
    module Method
      class Defined < Support::Command
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
        # @!attribute [r] klass
        #   @return [Class]
        #
        attr_reader :private

        ##
        # @param method [Symbol, String]
        # @param klass [Class]
        # @return [void]
        #
        def initialize(method, klass, private:)
          @method = method.to_s
          @klass = klass
          @private = private
        end

        ##
        # @return [void]
        #
        def call
          return true if klass.method_defined?(method)

          return klass.private_method_defined?(method) if private

          false
        end
      end
    end
  end
end
