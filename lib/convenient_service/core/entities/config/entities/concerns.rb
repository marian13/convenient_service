# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "concerns/entities"

module ConvenientService
  module Core
    module Entities
      class Config
        module Entities
          class Concerns
            ##
            # @param klass [Class]
            # @return [void]
            #
            def initialize(klass:)
              @klass = klass
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
            # Checks whether concerns are included into klass (include! was called at least once).
            #
            # @return [Boolean]
            #
            # @internal
            #   IMPORTANT: `included?` should be thread-safe.
            #
            def included?
              klass.include?(Entities::DefaultConcern)
            end

            ##
            # @param configuration_block [Proc]
            # @return [ConvenientService::Core::Entities::Config::Entities::Concerns]
            #
            def configure(&configuration_block)
              Utils::Proc.exec_config(configuration_block, stack)

              self
            end

            ##
            # Includes concerns into klass when called for the first time.
            # Does nothing for the subsequent calls.
            #
            # @return [Boolean] true if called for the first time, false otherwise (similarly as Kernel#require).
            #
            # @see https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-require
            #
            # @internal
            #   NOTE: Modification of instance variable is NOT thread-safe, that is why `Entities::DefaultConcern` is added.
            #   NOTE: `dup` is used for thread-safety as well.
            #
            def include!
              return false if included?

              klass.include(Entities::DefaultConcern)

              stack.call(klass: klass)

              true
            end

            ##
            # @param other [ConvenientService::Core::Entities::Config::Entities::Concerns, Object]
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if klass != other.klass
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
            # @!attribute [r] klass
            #   @return [Class]
            #
            attr_reader :klass

            ##
            # @return [ConvenientService::Core::Entities::Config::Entities::Concerns::Entities::Stack]
            #
            def stack
              @stack ||= Entities::Stack.new(name: stack_name, klass: klass)
            end

            private

            ##
            # @return [Array<Module>]
            #
            def plain_concerns
              stack.to_a.map(&:concern)
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

            ##
            # @return [String]
            #
            def stack_name
              "Concerns::#{klass}"
            end
          end
        end
      end
    end
  end
end
