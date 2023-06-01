# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeTried
                module Initialize
                  class Middleware < MethodChainMiddleware
                    intended_for :initialize, entity: :step

                    ##
                    # @param args [Array<Object>]
                    # @param kwargs [Hash{Symbol => Object}]
                    # @param block [Proc, nil]
                    # @return [void]
                    #
                    def next(*args, **kwargs, &block)
                      entity.internals.cache[:try] = kwargs[:try]

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
