# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveBeforeStepCallbacks
        class Middleware < MethodChainMiddleware
          intended_for :before, scope: :class, entity: :service

          ##
          # @api public
          #
          # @param method [Symbol]
          # @param block [Proc]
          # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
          #
          # @example Before `CanHaveBeforeStepCallbacks` usage.
          #   class Service
          #     include ::ConvenientService::Standard::Config
          #
          #     step :foo
          #
          #     class self::Step
          #       before :result do |arguments|
          #         organizer.instance_exec(arguments) do |arguments|
          #           log("before :step")
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
          # @example After `CanHaveBeforeStepCallbacks` usage.
          #   class Service
          #     include ::ConvenientService::Standard::Config
          #
          #     step :foo
          #
          #     before :step do |arguments|
          #       log("before :step")
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
              before :result do |arguments|
                organizer.instance_exec(arguments, &block)
              end
            end
          end
        end
      end
    end
  end
end
