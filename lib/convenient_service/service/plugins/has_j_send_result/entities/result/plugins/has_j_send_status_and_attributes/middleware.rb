# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Entities
          class Result
            module Plugins
              module HasJSendStatusAndAttributes
                class Middleware < MethodChainMiddleware
                  intended_for :initialize, entity: :result

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
