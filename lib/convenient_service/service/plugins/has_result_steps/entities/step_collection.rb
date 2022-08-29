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

              steps.each { |step| step.validate! && step.define! }.freeze

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
