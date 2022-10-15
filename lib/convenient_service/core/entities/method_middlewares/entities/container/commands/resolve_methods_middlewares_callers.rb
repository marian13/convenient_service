# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Entities
          class Container
            module Commands
              class ResolveMethodsMiddlewaresCallers < Support::Command
                include Support::Delegate

                ##
                # @!attribute [r] scope
                #   @return [:instance, :class]
                #
                attr_reader :scope

                ##
                # @!attribute [r] container
                #   @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                #
                attr_reader :container

                ##
                # @return [Class]
                #
                delegate :service_class, to: :container

                ##
                # @param scope [:instance, :scope]
                # @param container [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                # @return [void]
                #
                def initialize(scope:, container:)
                  @scope = scope
                  @container = container
                end

                ##
                # @return [Module]
                #
                def call
                  get_methods_middlewares_callers || set_methods_middlewares_callers
                end

                private

                ##
                # @return [Module, nil]
                #
                def get_methods_middlewares_callers
                  Utils::Module.get_own_const(service_class, module_name)
                end

                ##
                # @return [Module]
                #
                def set_methods_middlewares_callers
                  service_class.const_set(module_name, ::Module.new)
                end

                ##
                # @return [Symbol]
                #
                def module_name
                  @module_name ||= "#{scope.capitalize}MethodsMiddlewaresCallers".to_sym
                end
              end
            end
          end
        end
      end
    end
  end
end
