# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveAroundStepCallbacks
        class Middleware < MethodChainMiddleware
          intended_for :around, scope: :class, entity: :service

          ##
          # @api public
          #
          # @param method [Symbol]
          # @param block [Proc]
          # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
          #
          # @example Before `CanHaveAroundStepCallbacks` usage.
          #   class Service
          #     include ::ConvenientService::Standard::Config
          #
          #     step :foo
          #
          #     class self::Step
          #       around :step do |chain, arguments|
          #         organizer.instance_exec(chain, arguments) do |chain, arguments|
          #           step = chain.yield
          #
          #           log("around :step (#{step.index})")
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
          # @example After `CanHaveAroundStepCallbacks` usage.
          #   class Service
          #     include ::ConvenientService::Standard::Config
          #
          #     step :foo
          #
          #     around :step do |chain, arguments|
          #       step = chain.yield
          #
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
          def next(method, &block)
            return chain.next(method, &block) if method != :step

            entity.step_class.class_exec(block) do
              around :result do |chain, arguments|
                organizer.instance_exec(proc { chain.yield.step }, arguments, &block)
              end
            end
          end
        end
      end
    end
  end
end
