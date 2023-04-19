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
