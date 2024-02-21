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
              # @param expression [[ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
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
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Not]
              #
              def with_organizer(organizer)
                copy(overrides: {args: {0 => expression.with_organizer(organizer)}})
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

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if expression != other.expression

                true
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def to_arguments
                Support::Arguments.new(expression)
              end
            end
          end
        end
      end
    end
  end
end
