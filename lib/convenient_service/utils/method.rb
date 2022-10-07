# frozen_string_literal: true

require_relative "method/defined"
require_relative "method/find_own"

module ConvenientService
  module Utils
    module Method
      class << self
        ##
        # @param method_name [Symbol, String]
        # @param klass [Class]
        # @param private [Boolean]
        # @return [Boolean]
        #
        # @example
        #   ConvenientService::Utils::Method.defined?(:reverse, String)
        #
        def defined?(method_name, klass, private: false)
          Defined.call(method_name, klass, private: private)
        end

        def find_own(method_name, instance, **kwargs)
          FindOwn.call(method_name, instance, **kwargs)
        end
      end
    end
  end
end
