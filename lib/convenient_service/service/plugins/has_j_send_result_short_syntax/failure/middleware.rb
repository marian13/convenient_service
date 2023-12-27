# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Failure
          class Middleware < MethodChainMiddleware
            intended_for :failure, entity: :service

            ##
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def next(*args, **kwargs, &block)
              ::ConvenientService.raise Exceptions::BothArgsAndKwargsArePassed.new if args.any? && kwargs.any?

              args.any? ? failure_from_args : failure_from_kwargs
            end

            private

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def failure_from_args
              case next_arguments.args.size
              when 0 then chain.next
              when 1 then chain.next(message: next_arguments.args[0])
              when 2 then chain.next(message: next_arguments.args[0], code: next_arguments.args[1])
              else
                ::ConvenientService.raise Exceptions::MoreThanTwoArgsArePassed.new
              end
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            # @internal
            #   TODO: Constant for `[:data, :message, :code]`.
            #
            def failure_from_kwargs
              return chain.next(data: next_arguments.kwargs) if [:data, :message, :code].none? { |key| next_arguments.kwargs.has_key?(key) }

              ::ConvenientService.raise Exceptions::KwargsContainJSendAndExtraKeys.new if next_arguments.kwargs.keys.difference([:data, :message, :code]).any?

              chain.next(**next_arguments.kwargs)
            end
          end
        end
      end
    end
  end
end
