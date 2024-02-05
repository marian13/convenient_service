# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Not < Entities::Expressions::Base
              ##
              # @!attribute [r] expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              attr_reader :expression

              ##
              # @param expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              # @return [void]
              #
              def initialize(expression)
                @expression = expression
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                expression.result.negated_result
              end

              ##
              # @return [Array<Integer>]
              #
              def indices
                expression.indices
              end

              ##
              # @return [Boolean]
              #
              def success?
                expression.failure?
              end

              ##
              # @return [Boolean]
              #
              def failure?
                expression.success?
              end

              ##
              # @return [Boolean]
              #
              def error?
                expression.error?
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                expression.each_step(&block)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_evaluated_step(&block)
                expression.each_evaluated_step(&block)

                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              #
              def with_organizer(organizer)
                self.class.new(expression.with_organizer(organizer))
              end
            end
          end
        end
      end
    end
  end
end
