# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class ComplexIf < Entities::Expressions::Base
              ##
              # @!attribute [r] if_expressions
              #   @return [Array<ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base>]
              #
              attr_reader :if_expressions

              ##
              # @!attribute [r] else_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              attr_reader :else_expression

              ##
              #
              #
              attr_accessor :organizer

              ##
              # @param if_expressions [Array<ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base>]
              # @param else_expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base, nil]
              # @return [void]
              #
              def initialize(if_expressions, else_expression = nil)
                @if_expressions = if_expressions
                @else_expression = else_expression
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                if_expressions.each do |if_expression|
                  return if_expression.condition_expression.result if if_expression.condition_expression.error?
                  return if_expression.then_expression.result if if_expression.condition_expression.success?
                end

                else_expression ? else_expression.result : organizer.success
              end

              ##
              # @return [Boolean]
              #
              def success?
                if_expressions.each do |if_expression|
                  return false if if_expression.condition_expression.error?
                  return if_expression.then_expression.success? if if_expression.condition_expression.success?
                end

                else_expression ? else_expression.success? : true
              end

              ##
              # @return [Boolean]
              #
              def failure?
                if_expressions.each do |if_expression|
                  return false if if_expression.condition_expression.error?
                  return if_expression.then_expression.failure? if if_expression.condition_expression.success?
                end

                else_expression ? else_expression.failure? : false
              end

              ##
              # @return [Boolean]
              #
              def error?
                if_expressions.each do |if_expression|
                  return true if if_expression.condition_expression.error?
                  return if_expression.then_expression.error? if if_expression.condition_expression.success?
                end

                else_expression ? else_expression.error? : false
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                if_expressions.each { |if_expression| if_expression.each_step(&block) }

                else_expression&.each_step(&block)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_evaluated_step(&block)
                if_expressions.each do |if_expression|
                  if_expression.condition_expression.each_evaluated_step(&block)

                  return if if_expression.condition_expression.error?
                  return if_expression.then_expression.each_evaluated_step(&block) if if_expression.condition_expression.success?
                end

                else_expression&.each_evaluated_step(&block)

                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Not]
              #
              def with_organizer(organizer)
                copy(overrides: {args: {0 => if_expressions.map { |if_expression| if_expression.with_organizer(organizer) }, 1 => else_expression&.with_organizer(organizer)}})
                  .tap { |complex_if| complex_if.organizer = organizer }
              end

              ##
              # @return [String]
              #
              def inspect
                [
                  "if #{if_expressions.first.condition_expression.inspect} then #{if_expressions.first.then_expression.inspect}",
                  *if_expressions[1..].map { |if_expression| "elsif #{if_expression.condition_expression.inspect} then #{if_expression.then_expression.inspect}" },
                  "end"
                ]
                  .join(" ")
              end

              ##
              # @return [Boolean]
              #
              def complex_if?
                true
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if if_expressions != other.if_expressions
                return false if else_expression != other.else_expression

                true
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def to_arguments
                Support::Arguments.new(if_expressions, else_expression)
              end
            end
          end
        end
      end
    end
  end
end
