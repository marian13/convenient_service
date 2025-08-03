# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class ComplexIf < Entities::Expressions::Base
              ##
              # @!attribute [r] if_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If]
              #
              attr_reader :if_expression

              ##
              # @!attribute [r] elsif_expressions
              #   @return [Array<ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If>]
              #
              attr_reader :elsif_expressions

              ##
              # @!attribute [r] else_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Else]
              #
              attr_reader :else_expression

              ##
              #
              #
              attr_accessor :organizer

              ##
              # @param if_expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If]
              # @param elsif_expressions [Array<ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::If>]
              # @param else_expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Else, nil]
              # @return [void]
              #
              def initialize(if_expression, elsif_expressions, else_expression)
                @if_expression = if_expression
                @elsif_expressions = elsif_expressions
                @else_expression = else_expression
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                return if_expression.condition_expression.result if if_expression.condition_expression.error?
                return if_expression.then_expression.result if if_expression.condition_expression.success?

                elsif_expressions.each do |elsif_expression|
                  return elsif_expression.condition_expression.result if elsif_expression.condition_expression.error?
                  return elsif_expression.then_expression.result if elsif_expression.condition_expression.success?
                end

                else_expression ? else_expression.result : organizer.success
              end

              ##
              # @return [Boolean]
              #
              def success?
                return false if if_expression.condition_expression.error?
                return if_expression.then_expression.success? if if_expression.condition_expression.success?

                elsif_expressions.each do |elsif_expression|
                  return false if elsif_expression.condition_expression.error?
                  return elsif_expression.then_expression.success? if elsif_expression.condition_expression.success?
                end

                else_expression ? else_expression.success? : true
              end

              ##
              # @return [Boolean]
              #
              def failure?
                return false if if_expression.condition_expression.error?
                return if_expression.then_expression.failure? if if_expression.condition_expression.success?

                elsif_expressions.each do |elsif_expression|
                  return false if elsif_expression.condition_expression.error?
                  return elsif_expression.then_expression.failure? if elsif_expression.condition_expression.success?
                end

                else_expression ? else_expression.failure? : false
              end

              ##
              # @return [Boolean]
              #
              def error?
                return true if if_expression.condition_expression.error?
                return if_expression.then_expression.error? if if_expression.condition_expression.success?

                elsif_expressions.each do |elsif_expression|
                  return true if elsif_expression.condition_expression.error?
                  return elsif_expression.then_expression.error? if elsif_expression.condition_expression.success?
                end

                else_expression ? else_expression.error? : false
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                if_expression.each_step(&block)

                elsif_expressions.each do |elsif_expression|
                  elsif_expression.each_step(&block)
                end

                else_expression&.each_step(&block)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              # rubocop:disable Lint/NonLocalExitFromIterator
              def each_evaluated_step(&block)
                if_expression.condition_expression.each_evaluated_step(&block)

                return if if_expression.condition_expression.error?
                return if_expression.then_expression.each_evaluated_step(&block) if if_expression.condition_expression.success?

                elsif_expressions.each do |elsif_expression|
                  elsif_expression.condition_expression.each_evaluated_step(&block)

                  return if elsif_expression.condition_expression.error?
                  return elsif_expression.then_expression.each_evaluated_step(&block) if elsif_expression.condition_expression.success?
                end

                else_expression&.each_evaluated_step(&block)

                self
              end
              # rubocop:enable Lint/NonLocalExitFromIterator

              ##
              # @param organizer [ConvenientService::Service]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Not]
              #
              def with_organizer(organizer)
                copy(
                  overrides: {
                    args: {
                      0 => if_expression.with_organizer(organizer),
                      1 => elsif_expressions.map { |elsif_expression| elsif_expression.with_organizer(organizer) },
                      2 => else_expression&.with_organizer(organizer)
                    }
                  }
                )
                  .tap { |complex_if| complex_if.organizer = organizer }
              end

              ##
              # @return [String]
              #
              def inspect
                parts = [
                  "if #{if_expression.condition_expression.inspect} then #{if_expression.then_expression.inspect}"
                ]

                elsif_expressions.each do |elsif_expression|
                  parts << "elsif #{elsif_expression.condition_expression.inspect} then #{elsif_expression.then_expression.inspect}"
                end

                parts << "else #{else_expression.expression.inspect}" if else_expression

                parts << "end"

                parts.join(" ")
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

                return false if if_expression != other.if_expression
                return false if elsif_expressions != other.elsif_expressions
                return false if else_expression != other.else_expression

                true
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def to_arguments
                Support::Arguments.new(if_expression, elsif_expressions, else_expression)
              end
            end
          end
        end
      end
    end
  end
end
