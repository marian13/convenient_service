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
              @lock = ::Mutex.new
            end

            ##
            # TODO: Specs.
            #
            def commit!
              lock.synchronize do
                return false if committed?

                steps.each { |step| step.validate! && step.define! }.freeze

                true
              end
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

            attr_reader :lock

            def next_available_index
              steps.size
            end
          end
        end
      end
    end
  end
end
