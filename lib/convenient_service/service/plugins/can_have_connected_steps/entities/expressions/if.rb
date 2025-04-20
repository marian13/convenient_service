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
            class If < Entities::Expressions::Base
              ##
              # @!attribute [r] condition_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              attr_reader :condition_expression

              ##
              # @!attribute [r] then_expression
              #   @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              attr_reader :then_expression

              ##
              # @param condition_expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              # @param then_expression [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              # @return [void]
              #
              def initialize(condition_expression, then_expression)
                @condition_expression = condition_expression
                @then_expression = then_expression
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result
                condition_expression.success? ? then_expression.result : condition_expression.result
              end

              ##
              # @return [Boolean]
              #
              def success?
                condition_expression.success? && then_expression.success?
              end

              ##
              # @return [Boolean]
              #
              def failure?
                return true if condition_expression.failure?

                return then_expression.failure? if condition_expression.success?

                false
              end

              ##
              # @return [Boolean]
              #
              def error?
                return true if condition_expression.error?

                return then_expression.error? if condition_expression.success?

                false
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                condition_expression.each_step(&block)

                then_expression.each_step(&block)

                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_evaluated_step(&block)
                condition_expression.each_evaluated_step(&block)

                then_expression.each_evaluated_step(&block) if condition_expression.success?

                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Not]
              #
              def with_organizer(organizer)
                copy(overrides: {args: {0 => condition_expression.with_organizer(organizer), 1 => then_expression.with_organizer(organizer)}})
              end

              ##
              # @return [String]
              #
              def inspect
                "if #{condition_expression.inspect} then #{then_expression.inspect} end"
              end

              ##
              # @return [Boolean]
              #
              def if?
                true
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if condition_expression != other.condition_expression
                return false if then_expression != other.then_expression

                true
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def to_arguments
                Support::Arguments.new(condition_expression, then_expression)
              end
            end
          end
        end
      end
    end
  end
end
