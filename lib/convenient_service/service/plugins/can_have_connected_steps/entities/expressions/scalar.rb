# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Scalar < Entities::Expressions::Base
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
              # @return [Boolean]
              #
              def success?
                step.result.status.unsafe_success?
              end

              ##
              # @return [Boolean]
              #
              def failure?
                step.result.status.unsafe_failure?
              end

              ##
              # @return [Boolean]
              #
              def error?
                step.result.status.unsafe_error?
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar]
              #
              def each_step(&block)
                yield(step)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar]
              #
              # @internal
              #   NOTE: `step.result` is called to evaluate step.
              #
              def each_evaluated_step(&block)
                yield(step)

                step.result

                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Scalar]
              #
              def with_organizer(organizer)
                copy(overrides: {args: {0 => step.with_organizer(organizer)}})
              end

              ##
              # @return [String]
              #
              def inspect
                "steps[#{step.index}]"
              end

              ##
              # @return [Boolean]
              #
              def scalar?
                true
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if step != other.step

                true
              end

              ##
              # @return [ConvenientService::Support::Arguemnts]
              #
              def to_arguments
                Support::Arguments.new(step)
              end
            end
          end
        end
      end
    end
  end
end
