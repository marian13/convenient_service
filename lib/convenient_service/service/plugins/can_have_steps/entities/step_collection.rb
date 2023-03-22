# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class StepCollection
            include ::Enumerable

            ##
            # @!attribute [r] steps
            #   @return [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            #
            attr_reader :steps

            ##
            # @param steps [Array<ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step>]
            # @return [void]
            #
            def initialize(steps: [])
              @steps = steps
            end

            ##
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

              true
            end

            ##
            # TODO: Specs.
            #
            def committed?
              steps.frozen?
            end

            def each(&block)
              steps.each(&block)
            end

            ##
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

            def <<(step)
              steps << step.copy(overrides: {kwargs: {index: next_available_index}})
            end

            def ==(other)
              return unless other.instance_of?(self.class)

              return false if steps != other.steps

              true
            end

            private

            def next_available_index
              steps.size
            end
          end
        end
      end
    end
  end
end
