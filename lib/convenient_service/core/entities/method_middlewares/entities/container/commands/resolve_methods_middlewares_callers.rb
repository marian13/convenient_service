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
                # @!attribute [r] container
                #   @return [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                #
                attr_reader :container

                ##
                # @return [Class]
                #
                delegate :klass, to: :container

                ##
                # @param container [ConvenientService::Core::Entities::MethodMiddlewares::Entities::Container]
                # @return [void]
                #
                def initialize(container:)
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
                  Utils::Module.get_own_const(klass, module_name)
                end

                ##
                # @return [Module]
                #
                def set_methods_middlewares_callers
                  klass.const_set(module_name, ::Module.new)
                end

                ##
                # @return [Symbol]
                #
                def module_name
                  @module_name ||= :MethodsMiddlewaresCallers
                end
              end
            end
          end
        end
      end
    end
  end
end
