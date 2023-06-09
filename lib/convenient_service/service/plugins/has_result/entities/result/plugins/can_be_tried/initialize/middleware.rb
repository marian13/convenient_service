# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanBeTried
                module Initialize
                  class Middleware < MethodChainMiddleware
                    intended_for :initialize, entity: :result

                    ##
                    # @param args [Array<Object>]
                    # @param kwargs [Hash{Symbol => Object}]
                    # @param block [Proc, nil]
                    # @return [void]
                    #
                    def next(*args, **kwargs, &block)
                      entity.internals.cache[:try_result] = kwargs[:try_result]

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
