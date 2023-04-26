# frozen_string_literal: true

module ConvenientService
  module Utils
    module Module
      class GetOwnInstanceMethod < Support::Command
        include Support::FiniteLoop

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
        # @!attribute [r] max_iteration_count
        #   @return [Integer]
        #
        attr_reader :max_iteration_count

        ##
        # @param mod [Class, Module]
        # @param method_name [String, Symbol]
        # @param private [Boolean]
        # @param max_iteration_count [Integer]
        # @return [void]
        #
        def initialize(mod, method_name, private: false, max_iteration_count: Support::FiniteLoop::MAX_ITERATION_COUNT)
          @mod = mod
          @method_name = method_name
          @private = private
          @max_iteration_count = max_iteration_count
        end

        ##
        # @return [UnboundMethod, nil]
        #
        def call
          method = mod.instance_method(method_name) if has_own_instance_method?

          ##
          # TODO: Warn if exceeded.
          #
          finite_loop do
            break if method.nil?
            break if method.owner == mod

            method = method.super_method
          end

          method
        end

        private

        ##
        # @return [Boolean]
        #
        def has_own_instance_method?
          Utils::Module.has_own_instance_method?(mod, method_name, private: private)
        end

        ##
        # @return [Object] Block return value. Can be any type.
        #
        def finite_loop(&block)
          super(max_iteration_count: max_iteration_count, &block)
        end
      end
    end
  end
end
