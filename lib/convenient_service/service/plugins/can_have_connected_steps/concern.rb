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
            # Registers a step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def step(*args, **kwargs)
              previous_expression = steps.expression

              new_step = steps.create(*args, **kwargs)

              steps.expression =
                if previous_expression.empty?
                  Entities::Expressions::Scalar.new(new_step)
                else
                  Entities::Expressions::And.new(
                    previous_expression,
                    Entities::Expressions::Scalar.new(new_step)
                  )
                end
            end

            ##
            # @api public
            #
            # Registers a negated step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def not_step(*args, **kwargs)
              previous_expression = steps.expression

              new_step = steps.create(*args, **kwargs)

              steps.expression =
                if previous_expression.empty?
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Scalar.new(new_step)
                  )
                else
                  Entities::Expressions::And.new(
                    previous_expression,
                    Entities::Expressions::Not.new(
                      Entities::Expressions::Scalar.new(new_step)
                    )
                  )
                end
            end

            ##
            # @api public
            #
            # Registers a step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def and_step(*args, **kwargs)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              new_step = steps.create(*args, **kwargs)

              steps.expression =
                Entities::Expressions::And.new(
                  previous_expression,
                  Entities::Expressions::Scalar.new(new_step)
                )
            end

            ##
            # @api public
            #
            # Registers a negated step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def and_not_step(*args, **kwargs)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              new_step = steps.create(*args, **kwargs)

              steps.expression =
                Entities::Expressions::And.new(
                  previous_expression,
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Scalar.new(new_step)
                  )
                )
            end

            ##
            # @api public
            #
            # Registers an alternative step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            # @internal
            #   NOTE: Decomposing of the `and` expression is needed to make its priority higher.
            #
            def or_step(*args, **kwargs)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              new_step = steps.create(*args, **kwargs)

              steps.expression =
                if previous_expression.and?
                  Entities::Expressions::And.new(
                    previous_expression.left_expression,
                    Entities::Expressions::Or.new(
                      previous_expression.right_expression,
                      Entities::Expressions::Scalar.new(new_step)
                    )
                  )
                else
                  Entities::Expressions::Or.new(
                    previous_expression,
                    Entities::Expressions::Scalar.new(new_step)
                  )
                end
            end

            ##
            # @api public
            #
            # Registers a negated alternative step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            # @internal
            #   NOTE: Decomposing of the `and` expression is needed to make its priority higher.
            #
            def or_not_step(*args, **kwargs)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              new_step = steps.create(*args, **kwargs)

              steps.expression =
                if previous_expression.and?
                  Entities::Expressions::And.new(
                    previous_expression.left_expression,
                    Entities::Expressions::Or.new(
                      previous_expression.right_expression,
                      Entities::Expressions::Not.new(
                        Entities::Expressions::Scalar.new(new_step)
                      )
                    )
                  )
                else
                  Entities::Expressions::Or.new(
                    previous_expression,
                    Entities::Expressions::Not.new(
                      Entities::Expressions::Scalar.new(new_step)
                    )
                  )
                end
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def group(&block)
              previous_expression = steps.expression

              steps.expression = Entities::Expressions::Empty.new

              block&.call

              current_expression = steps.expression

              raise Exceptions::FirstGroupStepIsNotSet.new(container: self, method: __method__) if current_expression.empty?

              steps.expression =
                if previous_expression.empty?
                  Entities::Expressions::Group.new(current_expression)
                else
                  Entities::Expressions::And.new(
                    previous_expression,
                    Entities::Expressions::Group.new(current_expression)
                  )
                end
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def not_group(&block)
              previous_expression = steps.expression

              steps.expression = Entities::Expressions::Empty.new

              block&.call

              current_expression = steps.expression

              raise Exceptions::FirstGroupStepIsNotSet.new(container: self, method: __method__) if current_expression.empty?

              steps.expression =
                if previous_expression.empty?
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Group.new(current_expression)
                  )
                else
                  Entities::Expressions::And.new(
                    previous_expression,
                    Entities::Expressions::Not.new(
                      Entities::Expressions::Group.new(current_expression)
                    )
                  )
                end
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def and_group(&block)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              steps.expression = Entities::Expressions::Empty.new

              block&.call

              current_expression = steps.expression

              raise Exceptions::FirstGroupStepIsNotSet.new(container: self, method: __method__) if current_expression.empty?

              steps.expression =
                Entities::Expressions::And.new(
                  previous_expression,
                  Entities::Expressions::Group.new(current_expression)
                )
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            def and_not_group(&block)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              steps.expression = Entities::Expressions::Empty.new

              block&.call

              current_expression = steps.expression

              raise Exceptions::FirstGroupStepIsNotSet.new(container: self, method: __method__) if current_expression.empty?

              steps.expression =
                Entities::Expressions::And.new(
                  previous_expression,
                  Entities::Expressions::Not.new(
                    Entities::Expressions::Group.new(current_expression)
                  )
                )
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            # @internal
            #   NOTE: Decomposing of the `and` expression is needed to make its priority higher.
            #
            def or_group(&block)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              steps.expression = Entities::Expressions::Empty.new

              block&.call

              current_expression = steps.expression

              raise Exceptions::FirstGroupStepIsNotSet.new(container: self, method: __method__) if current_expression.empty?

              steps.expression =
                if previous_expression.and?
                  Entities::Expressions::And.new(
                    previous_expression.left_expression,
                    Entities::Expressions::Or.new(
                      previous_expression.right_expression,
                      Entities::Expressions::Group.new(current_expression)
                    )
                  )
                else
                  Entities::Expressions::Or.new(
                    previous_expression,
                    Entities::Expressions::Group.new(current_expression)
                  )
                end
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            # @internal
            #   NOTE: Decomposing of the `and` expression is needed to make its priority higher.
            #
            def or_not_group(&block)
              previous_expression = steps.expression

              raise Exceptions::FirstStepIsNotSet.new(container: self) if previous_expression.empty?

              steps.expression = Entities::Expressions::Empty.new

              block&.call

              current_expression = steps.expression

              raise Exceptions::FirstGroupStepIsNotSet.new(container: self, method: __method__) if current_expression.empty?

              steps.expression =
                if previous_expression.and?
                  Entities::Expressions::And.new(
                    previous_expression.left_expression,
                    Entities::Expressions::Or.new(
                      previous_expression.right_expression,
                      Entities::Expressions::Not.new(
                        Entities::Expressions::Group.new(current_expression)
                      )
                    )
                  )
                else
                  Entities::Expressions::Or.new(
                    previous_expression,
                    Entities::Expressions::Not.new(
                      Entities::Expressions::Group.new(current_expression)
                    )
                  )
                end
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
            #
            def steps
              internals_class.cache.fetch(:steps) { Entities::StepCollection.new(container: self) }
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
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
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
