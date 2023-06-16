# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module CanBePrinted
                  class Middleware < MethodChainMiddleware
                    intended_for :printable_service, entity: :step

                    ##
                    # @return [String]
                    #
                    def next(...)
                      return chain.next(...) unless entity.method_step?

                      ":#{entity.method}"
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
