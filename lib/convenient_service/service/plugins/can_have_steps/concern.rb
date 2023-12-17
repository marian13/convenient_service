# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Concern
          include Support::Concern

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
                  .map { |step| step.copy(overrides: {kwargs: {organizer: self}}) }
                  .freeze
              end
            end

            ##
            # Returns step by index.
            # Returns `nil` when index is out of range.
            #
            # @param index [Integer]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            # @note This method was initially designed as a hook (callback trigger).
            # @see ConvenientService::Service::Plugins::CanHaveSteps::Middleware#next
            #
            def step(index)
              steps[index]
            end
          end

          class_methods do
            ##
            # Registers a step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step(*args, **kwargs)
              step_class.new(*args, **kwargs.merge(container: self))
                .tap { |step_instance| steps << step_instance }
            end

            ##
            # Allows to pass a value to `in` method without its intermediate processing.
            # @see https://userdocs.convenientservice.org/basics/step_to_result_translation_table
            #
            # @example `:chat_v2` is passed to `AssertFeatureEnabled` as it is.
            #   step AssertFeatureEnabled, in: {name: raw(:chat_v2)}
            #   # that is converted to the following service invocation:
            #   AssertFeatureEnabled.result(name: :chat_v2)
            #
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Support::RawValue]
            #
            def raw(value)
              Support::RawValue.wrap(value)
            end

            ##
            # @param method_name [String, Symbol]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method::Entities::Values::Reassignment]
            #
            def reassign(method_name)
              Entities::Method::Entities::Values::Reassignment.new(method_name)
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::StepCollection]
            #
            def steps
              @steps ||= Entities::StepCollection.new
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step_class
              @step_class ||= Commands::CreateStepClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
