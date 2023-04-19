# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanHaveParentResult
                module Initialize
                  class Middleware < MethodChainMiddleware
                    def next(*args, **kwargs, &block)
                      entity.internals.cache[:parent] = kwargs[:parent]

                      chain.next(*args, **kwargs, &block)
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
