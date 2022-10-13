# frozen_string_literal: true

require_relative "concerns/entities"
require_relative "concerns/errors"

module ConvenientService
  module Core
    module Entities
      class Concerns
        ##
        # @return [void]
        #
        def initialize(entity:)
          @stack = Entities::Stack.new(entity: entity)
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def instance_method_defined?(method_name)
          return true if instance_method_defined_in_instance_methods_modules?(method_name)
          return true if instance_method_defined_directly?(method_name)

          false
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_instance_method_defined?(method_name)
          return true if private_instance_method_defined_in_instance_methods_modules?(method_name)
          return true if private_instance_method_defined_directly?(method_name)

          false
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def class_method_defined?(method_name)
          class_method_defined_in_class_methods_modules?(method_name)
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_class_method_defined?(method_name)
          private_class_method_defined_in_class_methods_modules?(method_name)
        end

        ##
        # @note: Concerns are included either by `commit_config` or `method_missing` from `ConvenientService::Core`.
        #
        # @return [void]
        #
        # @internal
        #   NOTE: Concerns must be included only once since Ruby does NOT allow to modify the order of modules in the inheritance chain.
        #   TODO: Redesign core to have an ability to change order of included/extended modules in v3? Does it really worth it?
        #
        def assert_not_included!
          return unless included?

          raise Errors::ConcernsAreIncluded.new(concerns: concerns)
        end

        ##
        # @param configuration_block [Proc]
        # @return [ConvenientService::Core::Entities::MethodMiddlewares]
        #
        # @internal
        #   TODO: Util to check if block has one required positional argument.
        #
        def configure(&configuration_block)
          Utils::Proc.exec_config(configuration_block, stack)

          self
        end

        ##
        # Includes concerns into entity when called for the first time.
        # Does nothing for the subsequent calls.
        #
        # @return [Boolean] true if called for the first time, false otherwise (similarly as Kernel#require).
        #
        # @see https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-require
        #
        def include!
          return false if included?

          stack.dup.insert_before(0, Entities::DefaultConcern).call(entity: stack.entity)

          true
        end

        ##
        # Checks whether concerns are included into entity (include! was called at least once).
        #
        # @return [Boolean]
        #
        # @internal
        #   IMPORTANT: `included?` should be thread-safe.
        #
        def included?
          stack.entity.include?(Entities::DefaultConcern)
        end

        ##
        # @param other [ConvenientService::Core::Entities::Concerns, Object]
        # @return [Boolean, nil]
        #
        def ==(other)
          return unless other.instance_of?(self.class)

          return false if stack != other.stack

          true
        end

        ##
        # @return [Array<Module>] concerns as plain modules.
        #
        def to_a
          plain_concerns
        end

        protected

        ##
        # @!attribute [r] stack
        #   @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
        #
        attr_reader :stack

        private

        ##
        # @return [Array<Module>]
        #
        def plain_concerns
          stack.to_a.map(&:first).map(&:concern)
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def instance_method_defined_directly?(method_name)
          plain_concerns.any? { |concern| concern.method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_instance_method_defined_directly?(method_name)
          plain_concerns.any? { |concern| concern.private_method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def instance_method_defined_in_instance_methods_modules?(method_name)
          instance_methods_modules.any? { |mod| mod.method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_instance_method_defined_in_instance_methods_modules?(method_name)
          instance_methods_modules.any? { |mod| mod.private_method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def class_method_defined_in_class_methods_modules?(method_name)
          class_methods_modules.any? { |mod| mod.method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_class_method_defined_in_class_methods_modules?(method_name)
          class_methods_modules.any? { |mod| mod.private_method_defined?(method_name) }
        end

        ##
        # @return [Array<Module>]
        #
        def instance_methods_modules
          plain_concerns.filter_map { |concern| Utils::Module.get_own_const(concern, :InstanceMethods) }
        end

        ##
        # @return [Array<Module>]
        #
        def class_methods_modules
          plain_concerns.filter_map { |concern| Utils::Module.get_own_const(concern, :ClassMethods) }
        end
      end
    end
  end
end
