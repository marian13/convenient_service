# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
          #     entity :Step do
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
          def next(method, **kwargs, &block)
            return chain.next(method, **kwargs, &block) if method != :step

            entity.step_class.class_exec(kwargs, block) do |kwargs, block|
              around :result, **kwargs.merge(source_location: block.source_location) do |chain|
                organizer.instance_exec(
                  proc { chain.yield.step },
                  params.to_callback_arguments,
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
