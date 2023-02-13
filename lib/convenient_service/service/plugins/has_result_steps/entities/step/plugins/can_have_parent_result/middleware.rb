# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Step
            module Plugins
              module CanHaveParentResult
                class Middleware < Core::MethodChainMiddleware
                  def next(...)
                    chain.next(...).copy(overrides: {kwargs: {parent: entity.original_result}})
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
