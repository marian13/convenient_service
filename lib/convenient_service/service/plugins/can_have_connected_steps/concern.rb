# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            #
            # Registers a negated step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step(*args, **kwargs)
              step_instance = steps.create(*args, **kwargs)

              steps.expression =
                if steps.any?
                  Entities::Expressions::And.new(
                    steps.expression,
                    Entities::Expressions::Atom.new(step_instance)
                  )
                else
                  Entities::Expressions::Atom.new(step_instance)
                end

              step_instance
            end

            ##
            # @api public
            #
            # Registers a negated step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def not_step(*args, **kwargs)
              step = steps.create(*args, **kwargs)

              steps.expression =
                if steps.any?
                  Entities::Expressions::And.new(
                    steps.expression,
                    Entities::Expressions::Not.new(
                      Entities::Expressions::Atom.new(step)
                    )
                  )
                else
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Atom.new(step)
                  )
                end

              step
            end

            ##
            # @api public
            #
            # Registers a step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def and_step(*args, **kwargs)
              raise Exceptions::FirstStepIsNotSet.new(container: self) if steps.none?

              step = steps.create(*args, **kwargs)

              steps.expression =
                Entities::Expressions::And.new(
                  steps.expression,
                  Entities::Expressions::Atom.new(step)
                )

              step
            end

            ##
            # @api public
            #
            # Registers a negated step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def and_not_step(*args, **kwargs)
              raise Exceptions::FirstStepIsNotSet.new(container: self) if steps.none?

              step = steps.create(*args, **kwargs)

              steps.expression =
                Entities::Expressions::And.new(
                  steps.expression,
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Atom.new(step)
                  )
                )

              step
            end

            ##
            # @api public
            #
            # Registers an alternative step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def or_step(*args, **kwargs)
              raise Exceptions::FirstStepIsNotSet.new(container: self) if steps.none?

              step = steps.create(*args, **kwargs)

              steps.expression =
                Entities::Expressions::Or.new(
                  steps.expression,
                  Entities::Expressions::Atom.new(step)
                )

              step
            end

            ##
            # @api public
            #
            # Registers an alternative step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def or_not_step(*args, **kwargs)
              raise Exceptions::FirstStepIsNotSet.new(container: self) if steps.none?

              step = steps.create(*args, **kwargs)

              steps.expression =
                Entities::Expressions::Or.new(
                  steps.expression,
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Atom.new(step)
                  )
                )

              step
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
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
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
            #
            def steps
              internals.cache.fetch(:steps) do
                self.class
                  .steps
                  .tap(&:commit!)
                  .with_organizer(self)
                  .tap(&:commit!)
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
            # @see ConvenientService::Service::Plugins::CanHaveConnectedSteps::Middleware#next
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
