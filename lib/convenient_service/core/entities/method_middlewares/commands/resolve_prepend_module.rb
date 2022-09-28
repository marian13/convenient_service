# frozen_string_literal: true

module ConvenientService
  module Core
    module Entities
      class MethodMiddlewares
        module Commands
          class ResolvePrependModule < Support::Command
            attr_reader :container, :scope

            def initialize(container:, scope:)
              @container = container
              @scope = scope
            end

            def call
              if container.const_defined?(module_name, false)
                container.const_get(module_name, false)
              else
                container.const_set(module_name, ::Module.new)
              end
            end

            private

            ##
            # TODO: Better module name.
            #
            def module_name
              @module_name ||= "Prepend#{scope.capitalize}Methods".to_sym
            end
          end
        end
      end
    end
  end
end
