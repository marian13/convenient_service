# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class None < Entities::Expressions::Base
              ##
              # @return [void]
              #
              def initialize
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::None::Exceptions::NoneHasNoResult]
              #
              def result
                raise Exceptions::NoneHasNoResult.new
              end

              ##
              # @return [Array<Integer>]
              #
              def indices
                []
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::None::Exceptions::NoneHasNoStatus]
              #
              def success?
                raise Exceptions::NoneHasNoStatus.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::None::Exceptions::NoneHasNoStatus]
              #
              def failure?
                raise Exceptions::NoneHasNoStatus.new
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::None::Exceptions::NoneHasNoStatus]
              #
              def error?
                raise Exceptions::NoneHasNoStatus.new
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
              #
              def with_organizer(organizer)
                self
              end

              ##
              # @return [Boolean]
              #
              def none?
                true
              end
            end
          end
        end
      end
    end
  end
end
