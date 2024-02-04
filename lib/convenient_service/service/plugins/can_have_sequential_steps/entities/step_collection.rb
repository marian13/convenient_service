# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSequentialSteps
        module Entities
          class StepCollection
            include ::Enumerable

            ##
            # @api private
            #
            # @!attribute [r] container
            #   @return [ConvenientService::Service]
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
            # @param container [ConvenientService::Service]
            # @param steps [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            # @return [void]
            #
            def initialize(container:, steps: [])
              @container = container
              @steps = steps
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
            end

            ##
            # @api private
            #
            # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def register(step)
              steps << step

              step
            end

            ##
            # @param organizer [ConvenientService::Service]
            # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::StepCollection]
            #
            def with_organizer(organizer)
              self.class.new(container: container, steps: steps.map { |step| step.with_organizer(organizer) })
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

              steps.each(&:define!).freeze

              freeze

              true
            end

            ##
            # @api public
            #
            # @return [Boolean]
            #
            def committed?
              steps.frozen?
            end

            ##
            # @api public
            #
            # @param block [Proc, nil]
            # @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>, Enumerator]
            #
            def each(&block)
              steps.each(&block)
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
            # @api public
            #
            # @param other [Object] Can be any type.
            # @return [Boolean, nil]
            #
            def ==(other)
              return unless other.instance_of?(self.class)

              return false if container != other.container
              return false if steps != other.steps

              true
            end

            private

            ##
            # @return [Integer]
            #
            def next_available_index
              steps.size
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
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
