# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeTried
                module Result
                  class Middleware < MethodChainMiddleware
                    intended_for :result

                    ##
                    # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                    #
                    def next(...)
                      result = chain.next(...)

                      return result unless entity.try?

                      return result.copy if result.success?

                      entity.try_result(...)
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
