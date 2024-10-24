# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveAfterStepCallbacks
        class Middleware < MethodChainMiddleware
          intended_for :after, scope: :class, entity: :service

          ##
          # @api public
          #
          # @param method [Symbol]
          # @param block [Proc]
          # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
          #
          # @example Before `CanHaveAfterStepCallbacks` usage.
          #   class Service
          #     include ::ConvenientService::Standard::Config
          #
          #     step :foo
          #
          #     entity :Step do
          #       after :result do |step, arguments|
          #         organizer.instance_exec(step, arguments) do |step, arguments|
          #           log("after :step (#{step.index})")
          #         end
          #       end
          #     end
          #
          #     def foo
          #       success
          #     end
          #
          #     private
          #
          #     def log(message)
          #       puts message
          #     end
          #   end
          #
          # @example After `CanHaveAfterStepCallbacks` usage.
          #   class Service
          #     include ::ConvenientService::Standard::Config
          #
          #     step :foo
          #
          #     after :step do |step, arguments|
          #       log("after :step (#{step.index})")
          #     end
          #
          #     def foo
          #       success
          #     end
          #
          #     private
          #
          #     def log(message)
          #       puts message
          #     end
          #   end
          #
          def next(method, **kwargs, &block)
            return chain.next(method, **kwargs, &block) if method != :step

            entity.step_class.class_exec(kwargs, block) do |kwargs, block|
              after :result, **kwargs.merge(source_location: block.source_location) do |result|
                organizer.instance_exec(
                  result.step,
                  Support::Arguments.new(
                    *args,
                    **Utils::Hash.except(self.kwargs, [:organizer, :container])
                  ),
                  &block
                )
              end
            end
          end
        end
      end
    end
  end
end
