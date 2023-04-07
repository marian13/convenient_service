# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasStep
                module Initialize
                  class Middleware < Core::MethodChainMiddleware
                    def next(*args, **kwargs, &block)
                      entity.internals.cache[:step] = kwargs[:step]

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