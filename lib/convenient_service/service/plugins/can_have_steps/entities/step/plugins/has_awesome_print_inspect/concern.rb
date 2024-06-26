# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module HasAwesomePrintInspect
                module Concern
                  include Support::Concern

                  instance_methods do
                    ##
                    # @return [String]
                    #
                    # @internal
                    #   NOTE: `ai` is a part of public interface of `awesome_print`.
                    #   - https://github.com/awesome-print/awesome_print#usage
                    #   - https://github.com/awesome-print/awesome_print/blob/master/lib/awesome_print/core_ext/kernel.rb
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

                      metadata[:ConvenientService].merge!(method_step? ? {method: ":#{method}"} : {service: service.klass.name})

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
