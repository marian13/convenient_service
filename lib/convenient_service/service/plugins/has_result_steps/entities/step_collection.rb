# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class StepCollection
            include ::Enumerable

            attr_reader :steps

            def initialize
              @steps = []
            end

            ##
            # TODO: Specs.
            #
            def commit!
              return false if committed?

              ##
              # IMPORTANT: Temporarily removed `step.validate!` since it is neither thread-safe nor idempotent.
              #
              steps.each { |step| step.define! }.freeze

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
            # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Step]
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
