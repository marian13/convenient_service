# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class And < Entities::Expressions::Base
              ##
              # @!attribute [r] left_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              attr_reader :left_expression

              ##
              # @!attribute [r] right_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              attr_reader :right_expression

              ##
              # @param left_expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              # @param right_expression [[ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              # @return [void]
              #
              def initialize(left_expression, right_expression)
                @left_expression = left_expression
                @right_expression = right_expression
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                left_expression.success? ? right_expression.result : left_expression.result
              end

              ##
              # @return [Array<Integer>]
              #
              def indices
                left_expression.indices + right_expression.indices
              end

              ##
              # @return [Boolean]
              #
              def success?
                left_expression.success? && right_expression.success?
              end

              ##
              # @return [Boolean]
              #
              def failure?
                return true if left_expression.failure?
                return false if left_expression.error?

                right_expression.failure?
              end

              ##
              # @return [Boolean]
              #
              def error?
                left_expression.error? || right_expression.error?
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                left_expression.each_step(&block)
                right_expression.each_step(&block)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_evaluated_step(&block)
                left_expression.each_evaluated_step(&block)

                right_expression.each_evaluated_step(&block) if left_expression.success?

                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              #
              def with_organizer(organizer)
                self.class.new(left_expression.with_organizer(organizer), right_expression.with_organizer(organizer))
              end
            end
          end
        end
      end
    end
  end
end
