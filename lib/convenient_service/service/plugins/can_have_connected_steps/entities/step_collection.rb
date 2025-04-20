# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          ##
          # @internal
          #   NOTE:
          #     This class is a modernization of `StepCollection` from `HasSequentialSteps`.
          #     Compared to the original implementation, this one is based on `expression` objects.
          #     `steps` array is not mandatory since each `step` can be retrieved from `expression`, but it is left for better performance.
          #     `expression` objects are trees. Search by index in the tree is O(n), while the same lookup in the array is O(1).
          #
          class StepCollection
            include ::Enumerable

            include Support::Copyable

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
            # @!attribute [r] steps
            #   @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            #
            attr_reader :steps

            ##
            # @api private
            #
            # @param container [Class<ConvenientService::Service>]
            # @param expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
            # @param steps [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            # @return [void]
            #
            def initialize(container:, expression: Entities::Expressions::Empty.new, steps: [])
              @container = container
              @expression = expression
              @steps = steps
            end

            ##
            # @return [Integer]
            #
            def size
              steps.size
            end

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoResult]
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
                .tap { |step| steps << step }
            end

            ##
            # @param organizer [ConvenientService::Service]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
            #
            def with_organizer(organizer)
              expression_with_organizer = expression.with_organizer(organizer)

              if frozen?
                copy(overrides: {kwargs: {expression: expression_with_organizer.freeze, steps: expression_with_organizer.steps.freeze}}).freeze
              else
                copy(overrides: {kwargs: {expression: expression_with_organizer, steps: expression_with_organizer.steps}})
              end
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

              steps.freeze

              freeze

              true
            end

            ##
            # @api public
            #
            # @return [Boolean]
            #
            def committed?
              frozen?
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

            ##
            # @return [String]
            #
            def inspect
              expression.inspect
            end

            ##
            # @api public
            #
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if container != other.container
              return false if expression != other.expression
              return false if steps != other.steps

              true
            end

            ##
            # @return [ConvenientService::Support::Arguments]
            #
            def to_arguments
              Support::Arguments.new(container: container, expression: expression, steps: steps)
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
