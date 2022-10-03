# frozen_string_literal: true

module ConvenientService
  module Utils
    module Method
      class FindOwn < Support::Command
        include Support::FiniteLoop

        attr_reader :method_name, :instance, :max_iteration_count

        def initialize(method_name, instance, max_iteration_count: Support::FiniteLoop::MAX_ITERATION_COUNT)
          @method_name = method_name
          @instance = instance
          @max_iteration_count = max_iteration_count
        end

        def call
          # method = instance.method(method_name) if instance.respond_to?(method_name, true)

          method = instance.method(method_name) if instance.respond_to?(method_name)

          finite_loop do
            break if method.nil?
            break if method.owner == instance.class

            method = method.super_method
          end

          method
        end

        private

        def finite_loop(&block)
          super(max_iteration_count: max_iteration_count, &block)
        end
      end
    end
  end
end
