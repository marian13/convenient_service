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
              if kwargs.any?
                Commands::RefuteKwargsContainJSendAndExtraKeys[kwargs: kwargs]

                return ([:data, :message, :code].any? { |key| kwargs.has_key?(key) }) ? chain.next(**kwargs) : chain.next(data: kwargs)
              end

              if args.size == 0
                chain.next
              elsif args.size == 1
                chain.next(message: args[0])
              elsif args.size >= 2
                chain.next(message: args[0], code: args[1])
              end
            end
          end
        end
      end
    end
  end
end
