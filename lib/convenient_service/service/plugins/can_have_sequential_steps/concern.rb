# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSequentialSteps
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            #
            # Registers a step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step(*args, **kwargs)
              steps.register(steps.create(*args, **kwargs))
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::StepCollection]
            #
            def steps
              @steps ||= Entities::StepCollection.new(container: self)
            end
          end

          instance_methods do
            ##
            # @api public
            #
            # @note May be useful for debugging purposes.
            # @see https://userdocs.convenientservice.org/guides/how_to_debug_services_via_callbacks
            #
            # @note `steps` are frozen.
            # @see https://userdocs.convenientservice.org/faq#is-it-possible-to-modify-the-step-collection-from-a-callback
            #
            # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            #
            # @internal
            #   IMPORTANT: `map` result is NOT wrapped by `StepCollection` in order to NOT expose too much internals to the end-user.
            #
            def steps
              internals.cache.fetch(:steps) do
                self.class
                  .steps
                  .tap(&:commit!)
                  .map { |step| step.with_organizer(self) }
                  .freeze
              end
            end

            ##
            # @api private
            #
            # Returns step by index.
            # Returns `nil` when index is out of range.
            #
            # @param index [Integer]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            # @note This method was initially designed as a hook (callback trigger).
            # @see ConvenientService::Service::Plugins::CanHaveSequentialSteps::Middleware#next
            #
            def step(index)
              steps[index]
            end
          end
        end
      end
    end
  end
end
