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
                  def next(*args, **kwargs, &block)
                    entity.internals.cache[:jsend_attributes] = Commands::CastJSendAttributes.call(params: kwargs)

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
