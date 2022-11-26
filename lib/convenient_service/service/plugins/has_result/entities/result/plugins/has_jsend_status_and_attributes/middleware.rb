# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Entities
          class Result
            module Plugins
              module HasJsendStatusAndAttributes
                class Middleware < Core::MethodChainMiddleware
                  ##
                  # @param args [Array]
                  # @param kwargs [Hash]
                  # @param block [Proc]
                  # @return [void]
                  #
                  def next(*args, **kwargs, &block)
                    entity.internals.cache[:jsend_attributes] = Commands::CastJSendAttributes.call(attributes: kwargs)

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
