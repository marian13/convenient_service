# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveParentResult
                module ToKwargs
                  class Middleware < Core::MethodChainMiddleware
                    def next(...)
                      chain.next(...).merge(parent: entity.parent)
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
