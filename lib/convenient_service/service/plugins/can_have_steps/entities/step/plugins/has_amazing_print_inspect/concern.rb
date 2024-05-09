# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module HasAmazingPrintInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    # @internal
                    #   NOTE: `ai` is a part of public interface of `awesome_print`.
                    #   - https://github.com/amazing-print/amazing_print?tab=readme-ov-file#usage
                    #   - https://github.com/amazing-print/amazing_print/blob/master/lib/amazing_print/core_ext/kernel.rb
                    #
                    #   TODO: `inspect_values` for class. This way `service_class.name || ...` can be shared.
                    #
                    def inspect
                      metadata = {
                        ConvenientService: {
                          entity: "Step",
                          container: container.klass.name,
                          **(method_step? ? {method: ":#{method}"} : {service: service.klass.name})
                        }
                      }

                      metadata.ai
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
