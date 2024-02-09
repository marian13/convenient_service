# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          class StepCollection
            include ::Enumerable

            ##
            # @api private
            #
            # @!attribute [r] container
            #   @return [Class<ConvenientService::Service>]
            #
            attr_reader :container

            ##
            # @api private
            #
            # @!attribute [r] steps
            #   @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            #
            attr_reader :steps

            ##
            # @api private
            #
            # @!attribute [r] expression
            #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            attr_accessor :expression

            ##
            # @api private
            #
            # @param container [Class<ConvenientService::Service>]
            # @param steps [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            # @param expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            # @return [void]
            #
            def initialize(container:, steps: [], expression: Entities::Expressions::None.new)
              @container = container
              @steps = steps
              @expression = expression
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::None::Exceptions::NoneHasNoResult]
            #
            def result
              expression.result
            end

            ##
            # @return [Array<Integer>]
            #
            def indices
              expression.indices
            end

            ##
            # @api private
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def create(*args, **kwargs)
              step = step_class.new(*args, **kwargs.merge(container: container, index: next_available_index))

              steps << step

              step
            end

            ##
            # @param organizer [ConvenientService::Service]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
            #
            def with_organizer(organizer)
              self.class.new(container: container, steps: steps, expression: expression.with_organizer(organizer))
            end

            ##
            # @api public
            #
            # @return [Boolean] true if called for the first time, false otherwise (similarly as Kernel#require).
            #
            # @see https://ruby-doc.org/core-3.1.2/Kernel.html#method-i-require
            #
            # @internal
            #   IMPORTANT: `step.validate!` is intentionally removed from `steps.each { |step| step.validate! && step.define! }.freeze` since it is NOT idempotent.
            #
            #   NOTE: `step.validate!` is still useful as a `doctor` command.
            #
            def commit!
              return false if committed?

              expression.each_step(&:define!).freeze

              freeze

              true
            end

            ##
            # @api public
            #
            # @return [Boolean]
            #
            def committed?
              expression.frozen?
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>, Enumerator]
            #
            def each(&block)
              expression.each_step(&block)
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>, Enumerator]
            #
            def each_step(&block)
              expression.each_step(&block)
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>, Enumerator]
            #
            def each_evaluated_step(&block)
              expression.each_evaluated_step(&block)
            end

            ##
            # @api public
            #
            # Returns step by index.
            #
            # @param index [Integer]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            # @note Works in a similar way as `Array#[]`.
            # @see https://ruby-doc.org/core-2.7.0/Array.html#method-i-5B-5D
            #
            def [](index)
              steps[index]
            end

            private

            ##
            # @return [Integer]
            #
            def next_available_index
              steps.size
            end

            ##
            # @return [Class<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            #
            def step_class
              container.step_class
            end
          end
        end
      end
    end
  end
end
