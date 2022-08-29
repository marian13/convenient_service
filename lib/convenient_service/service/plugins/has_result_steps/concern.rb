# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Concern
          include Support::Concern

          instance_methods do
            def steps
              @steps ||=
                self.class
                  .steps
                  .tap(&:commit!)
                  .map { |step| step.copy(overrides: {kwargs: {organizer: self}}) }
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
            # NOTE: Allows to pass a value to `in' method without processing it.
            #
            def raw(value)
              Entities::Method::Entities::Values::Raw.wrap(value)
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
