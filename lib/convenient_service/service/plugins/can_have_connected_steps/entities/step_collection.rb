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
            # @!attribute [r] expression
            #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            #
            attr_accessor :expression

            ##
            # @api private
            #
            # @param container [Class<ConvenientService::Service>]
            # @param expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            # @return [void]
            #
            def initialize(container:, expression: Entities::Expressions::None.new)
              @container = container
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
            # @api private
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def create(*args, **kwargs)
              step_class.new(*args, **kwargs.merge(container: container, index: next_available_index))
                .tap { self.next_available_index += 1 }
            end

            ##
            # @param organizer [ConvenientService::Service]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
            #
            def with_organizer(organizer)
              self.class.new(container: container, expression: expression.with_organizer(organizer))
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

            private

            ##
            # @!attribute [r] next_available_index
            #   @return [Integer]
            #
            attr_writer :next_available_index

            ##
            # @return [Integer]
            #
            def next_available_index
              @next_available_index ||= 0
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
