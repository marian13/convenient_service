# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Atom < Entities::Expressions::Base
              ##
              # @!attribute [r] step
              #   @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
              #
              attr_reader :step

              ##
              # @param step [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
              # @return [void]
              #
              def initialize(step)
                @step = step
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                step.result
              end

              ##
              # @return [Array<Integer>]
              #
              def indices
                [step.index]
              end

              ##
              # @return [Boolean]
              #
              def success?
                step.success?
              end

              ##
              # @return [Boolean]
              #
              def failure?
                step.failure?
              end

              ##
              # @return [Boolean]
              #
              def error?
                step.error?
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                yield(step)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_evaluated_step(&block)
                yield(step)

                step.tap(&:result) # For before hook? For completed step?

                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              #
              def with_organizer(organizer)
                self.class.new(step.with_organizer(organizer))
              end

              ##
              # @return [String]
              #
              def inspect
                "steps[#{step.index}]"
              end
            end
          end
        end
      end
    end
  end
end
