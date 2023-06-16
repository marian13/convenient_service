# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveMethodSteps
        class Middleware < MethodChainMiddleware
          intended_for :step, scope: :class, entity: :service

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
          #
          def next(*args, **kwargs, &block)
            return chain.next(*args, **kwargs, &block) unless args.first.instance_of?(::Symbol)

            chain.next(entity, *args[1..], **kwargs.merge(method: args.first), &block)
          end
        end
      end
    end
  end
end
