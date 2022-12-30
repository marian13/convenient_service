# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Concern
          include Support::Concern

          instance_methods do
            def steps
              internals.cache.fetch(:steps) do
                self.class
                  .steps
                  .tap(&:commit!)
                  .map { |step| step.copy(overrides: {kwargs: {organizer: self}}) }
              end
            end

            ##
            # TODO: Create for callbacks.
            #
            #   def step(step_result)
            #     step_result
            #   end
            #
          end

          class_methods do
            def step(*args, **kwargs)
              step_class.new(*args, **kwargs.merge(container: self))
                .tap { |step_instance| steps << step_instance }
            end

            ##
            # Allows to pass a value to `in` method without its intermediate processing.
            # @see https://marian13.github.io/convenient_service_docs/basics/step_to_result_translation_table
            #
            # @example `:chat_v2` is passed to `AssertFeatureEnabled` as it is.
            #   step AssertFeatureEnabled, in: {name: raw(:chat_v2)}
            #   # that is converted to the following service invocation:
            #   AssertFeatureEnabled.result(name: :chat_v2)
            #
            def raw(value)
              Support::RawValue.wrap(value)
            end

            def steps
              @steps ||= Entities::StepCollection.new
            end

            def step_class
              @step_class ||= Commands::CreateStepClass.call(service_class: self)
            end
          end
        end
      end
    end
  end
end
