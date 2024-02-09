# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Group < Entities::Expressions::Base
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
                expression.result
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
                expression.success?
              end

              ##
              # @return [Boolean]
              #
              def failure?
                expression.failure?
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

              ##
              # @return [String]
              #
              def inspect
                "(#{expression.inspect})"
              end

              ##
              # @return [Boolean]
              #
              def group?
                true
              end
            end
          end
        end
      end
    end
  end
end
