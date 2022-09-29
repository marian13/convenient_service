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

                attr_reader :scope, :container

                delegate :service_class, to: :container

                def initialize(scope:, container:)
                  @scope = scope
                  @container = container
                end

                ##
                # @return [Module]
                #
                def call
                  if service_class.const_defined?(module_name, false)
                    service_class.const_get(module_name, false)
                  else
                    service_class.const_set(module_name, ::Module.new)
                  end
                end

                private

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
