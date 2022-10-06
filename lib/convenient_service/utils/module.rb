# frozen_string_literal: true

require_relative "module/get_own_instance_method"
require_relative "module/find_own_const"
require_relative "module/has_own_instance_method"

module ConvenientService
  module Utils
    ##
    # NOTE: `Class` is descendant of `Module`, that is why `Module` is more generic term.
    # TODO: Better generic term for both `Module` and `Class`.
    #
    module Module
      class << self
        ##
        # @param mod [Class, Module]
        # @param method_name [Symbol, String]
        # @param private [Boolean]
        # @param max_iteration_count [Integer]
        # @return [UnboundMethod, nil]
        #
        def get_own_instance_method(mod, method_name, private: false, max_iteration_count: Support::FiniteLoop::MAX_ITERATION_COUNT)
          GetOwnInstanceMethod.call(mod, method_name, private: private, max_iteration_count: max_iteration_count)
        end

        ##
        # @param mod [Class, Module]
        # @param const_name [Symbol]
        # @return [Object] Value of own const. Can be any type.
        #
        # @example:
        #   ConvenientService::Utils::Module.find_own_const(Object, :File)
        #   ConvenientService::Utils::Module.find_own_const(Class, :File)
        #
        def find_own_const(mod, const_name)
          FindOwnConst.call(mod, const_name)
        end

        ##
        # @param mod [Class, Module]
        # @param method [String, Symbol]
        # @param private [Boolean]
        # @return [Boolean]
        #
        def has_own_instance_method?(mod, method, private: true)
          HasOwnInstanceMethod.call(mod, method, private: private)
        end
      end
    end
  end
end
