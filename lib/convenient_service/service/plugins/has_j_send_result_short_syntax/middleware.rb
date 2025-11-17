# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        class Middleware < MethodChainMiddleware
          intended_for [:success, :failure, :error], entity: :service

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def next(*args, **kwargs, &block)
            ::ConvenientService.raise Exceptions::BothArgsAndKwargsArePassed.new(status: method) if args.any? && kwargs.any?

            kwargs.any? ? result_from_kwargs : result_from_args
          end

          private

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def result_from_args
            case next_arguments.args.size
            when 0 then chain.next
            when 1 then chain.next(message: next_arguments.args[0])
            when 2 then chain.next(message: next_arguments.args[0], code: next_arguments.args[1])
            else
              ::ConvenientService.raise Exceptions::MoreThanTwoArgsArePassed.new(status: method)
            end
          end

          ##
          # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
          #
          def result_from_kwargs
            return chain.next(data: next_arguments.kwargs) if [:data, :message, :code].none? { |key| next_arguments.kwargs.has_key?(key) }

            ::ConvenientService.raise Exceptions::KwargsContainJSendAndExtraKeys.new(status: method) if next_arguments.kwargs.keys.difference([:data, :message, :code]).any?

            chain.next(**next_arguments.kwargs)
          end
        end
      end
    end
  end
end
