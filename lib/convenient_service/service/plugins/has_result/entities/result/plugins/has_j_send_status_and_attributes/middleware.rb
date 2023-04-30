# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                class Middleware < MethodChainMiddleware
                  intended_for :initialize

                  ##
                  # @param args [Array<Object>]
                  # @param kwargs [Hash{Symbol => Object}]
                  # @param block [Proc, nil]
                  # @return [void]
                  #
                  def next(*args, **kwargs, &block)
                    entity.internals.cache[:jsend_attributes] = Commands::CastJSendAttributes.call(result: entity, kwargs: kwargs)

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
