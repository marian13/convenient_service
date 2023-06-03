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
                  class Middleware < MethodChainMiddleware
                    intended_for :to_kwargs, entity: :result

                    ##
                    # @internal
                    #   TODO: What if result is created from method step? Who is its parent?
                    #
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
