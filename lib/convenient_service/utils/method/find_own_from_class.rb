# frozen_string_literal: true

##
# @example
#   ConvenientService::Utils::Method::FindOwnFromClass
#
module ConvenientService
  module Utils
    module Method
      class FindOwnFromClass < Support::Command
        include Support::FiniteLoop

        attr_reader :method_name, :klass, :max_iteration_count

        def initialize(method_name, klass, max_iteration_count: Support::FiniteLoop::MAX_ITERATION_COUNT)
          @method_name = method_name
          @klass = klass
          @max_iteration_count = max_iteration_count
        end

        def call
          method = klass.instance_method(method_name) if klass.instance_methods(false).include?(method_name) || klass.private_instance_methods(false).include?(method_name)

          finite_loop do
            break if method.nil?
            break if method.owner == klass

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

# self.class.ancestors.drop_while { |mod| mod != self.class::InstanceMethodsMiddlewaresCallers }.drop(1).find { |mod| mod.instance_methods(false).include?(method) || mod.private_instance_methods(false).include?(method) }.then { |mod| ConvenientService::Utils::Method.find_own_from_class(method, mod) }
