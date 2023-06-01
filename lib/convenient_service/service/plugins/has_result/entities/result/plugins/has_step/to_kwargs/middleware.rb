# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasStep
                module ToKwargs
                  class Middleware < MethodChainMiddleware
                    intended_for :to_kwargs, entity: :result

                    def next(...)
                      chain.next(...).merge(step: entity.step)
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
