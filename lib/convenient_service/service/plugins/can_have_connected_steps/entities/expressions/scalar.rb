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
              # @internal
              #   IMPORTANT: `success?` calls `result` to be able to use the same RSpec spy for both `success?` and `result?`.
              #
              def success?
                result.status.unsafe_success?
              end

              ##
              # @return [Boolean]
              #
              # @internal
              #   IMPORTANT: `failure?` calls `result` to be able to use the same RSpec spy for both `failure?` and `result?`.
              #
              def failure?
                result.status.unsafe_failure?
              end

              ##
              # @return [Boolean]
              #
              # @internal
              #   IMPORTANT: `error?` calls `result` to be able to use the same RSpec spy for both `error?` and `result?`.
              #
              def error?
                result.status.unsafe_error?
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
              #   NOTE: `result` is called to evaluate step.
              #   IMPORTANT: `each_evaluated_step` calls `result` to be able to use the same RSpec spy for both `each_evaluated_step` and `result?`.
              #
              def each_evaluated_step(&block)
                yield(step)

                result

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
              # @return [ConvenientService::Support::Arguments]
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
