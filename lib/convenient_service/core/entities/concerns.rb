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
        def method_defined?(method_name)
          return true if method_defined_in_instance_methods_modules?(method_name)
          return true if method_defined_directly?(method_name)

          false
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_method_defined?(method_name)
          return true if private_method_defined_in_instance_methods_modules?(method_name)
          return true if private_method_defined_directly?(method_name)

          false
        end

        ##
        # @return [void]
        #
        def assert_not_included!
          return unless included?

          raise Errors::ConcernsAreIncluded.new(concerns: concerns)
        end

        ##
        # @return [void]
        #
        def configure(&configuration_block)
          stack.instance_exec(&configuration_block)
        end

        ##
        # Includes concerns into entity when called for the first time.
        # Does nothing for the subsequent calls.
        #
        # @return [Boolean] true if called for the first time, false otherwise.
        #
        def include!
          return false if included?

          stack.call(entity: stack.entity)

          mark_as_included!

          true
        end

        ##
        # Checks whether concerns are included into entity (include! was called at least once).
        #
        # @return [Boolean]
        #
        def included?
          Utils::Bool.to_bool(@included)
        end

        ##
        # @return [Array<Module>] concerns as plain modules.
        #
        def to_a
          plain_concerns
        end

        private

        ##
        # @!attribute [r] stack
        #   @return [ConvenientService::Core::Entities::Concerns::Entities::Stack]
        #
        attr_reader :stack

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
        def method_defined_in_instance_methods_modules?(method_name)
          instance_methods_modules.any? { |mod| mod.method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_method_defined_in_instance_methods_modules?(method_name)
          instance_methods_modules.any? { |mod| mod.private_method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def method_defined_directly?(method_name)
          plain_concerns.any? { |concern| concern.method_defined?(method_name) }
        end

        ##
        # @param method_name [Symbol, String]
        # @return [Boolean]
        #
        def private_method_defined_directly?(method_name)
          plain_concerns.any? { |concern| concern.private_method_defined?(method_name) }
        end

        ##
        # @return [Array<Module>]
        #
        def instance_methods_modules
          plain_concerns
            .select { |concern| concern.const_defined?(:InstanceMethods, false) }
            .map { |concern| concern.const_get(:InstanceMethods) }
        end

        ##
        # @return [void]
        #
        def mark_as_included!
          @included = true
        end
      end
    end
  end
end
