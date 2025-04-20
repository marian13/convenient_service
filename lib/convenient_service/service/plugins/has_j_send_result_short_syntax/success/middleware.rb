# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Success
          class Middleware < MethodChainMiddleware
            intended_for :success, entity: :service

            ##
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def next(*args, **kwargs, &block)
              Commands::RefuteKwargsContainJSendAndExtraKeys[kwargs: kwargs]

              ([:data, :message, :code].any? { |key| kwargs.has_key?(key) }) ? chain.next(**kwargs) : chain.next(data: kwargs)
            end
          end
        end
      end
    end
  end
end
