# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @return [Array]
            #
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
            ##
            # @params args [Array]
            # @params kwargs [Hash]
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
            #
            def step(*args, **kwargs)
              step_class.new(*args, **kwargs.merge(container: self))
                .tap { |step_instance| steps << step_instance }
            end

            ##
            # @param value [Object] Can be any type.
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Values::Raw]
            #
            # @internal
            #   NOTE: Allows to pass a value to `in` method without processing it.
            #
            def raw(value)
              Entities::Method::Entities::Values::Raw.wrap(value)
            end

            ##
            # @param method_name [String, Symbol]
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method::Entities::Values::Reassignment]
            #
            def reassign(method_name)
              Entities::Method::Entities::Values::Reassignment.new(method_name)
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::StepCollection]
            #
            def steps
              @steps ||= Entities::StepCollection.new
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
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
