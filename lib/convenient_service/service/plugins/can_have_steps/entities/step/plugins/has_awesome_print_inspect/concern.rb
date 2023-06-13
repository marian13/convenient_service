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
                    def inspect
                      metadata = {
                        ConvenientService: {
                          entity: "Step",
                          container: container.klass.name,
                          **(method_step? ? {method: method.value.to_sym} : {service: service.klass.name})
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
