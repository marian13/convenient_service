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
                    #   NOTE: `ai` is a part of public interface of `amazing_print`.
                    #   - https://github.com/amazing-print/amazing_print?tab=readme-ov-file#usage
                    #   - https://github.com/amazing-print/amazing_print/blob/master/lib/amazing_print/core_ext/kernel.rb
                    #
                    #   TODO: `inspect_values` for class. This way `service_class.name || ...` can be shared.
                    #
                    def inspect
                      metadata = {
                        ConvenientService: {
                          entity: "Step",
                          container: container.klass.name
                        }
                      }

                      metadata[:ConvenientService][:method] = ":#{method}" if method_step?
                      metadata[:ConvenientService][:service] = service_class.name if service_step?

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
