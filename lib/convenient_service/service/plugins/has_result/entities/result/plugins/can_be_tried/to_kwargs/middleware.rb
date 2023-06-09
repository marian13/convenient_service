# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module CanBeTried
                module ToKwargs
                  class Middleware < MethodChainMiddleware
                    intended_for :to_kwargs, entity: :result

                    ##
                    # @return [Hash{Symbol => Object}]
                    #
                    def next(...)
                      chain.next(...).merge(try_result: entity.try_result?)
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
