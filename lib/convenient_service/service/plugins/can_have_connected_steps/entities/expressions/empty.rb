# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Empty < Entities::Expressions::Base
              ##
              # @return [void]
              #
              def initialize
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoResult]
              #
              def result
                ::ConvenientService.raise Exceptions::EmptyExpressionHasNoResult.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus]
              #
              def success?
                ::ConvenientService.raise Exceptions::EmptyExpressionHasNoStatus.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus]
              #
              def failure?
                ::ConvenientService.raise Exceptions::EmptyExpressionHasNoStatus.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Exceptions::EmptyExpressionHasNoStatus]
              #
              def error?
                ::ConvenientService.raise Exceptions::EmptyExpressionHasNoStatus.new
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_step(&block)
                self
              end

              ##
              # @param block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              def each_evaluated_step(&block)
                self
              end

              ##
              # @param organizer [ConvenientService::Service]
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Empty]
              #
              def with_organizer(organizer)
                self
              end

              ##
              # @return [String]
              #
              def inspect
                ""
              end

              ##
              # @return [Boolean]
              #
              def empty?
                true
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                true
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def to_arguments
                Support::Arguments.new
              end
            end
          end
        end
      end
    end
  end
end
