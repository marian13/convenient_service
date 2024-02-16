# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Base
              include Support::AbstractMethod
              include Support::Copyable

              ##
              # @return [void]
              #
              abstract_method :initialize

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              abstract_method :result

              ##
              # @return [Boolean]
              #
              abstract_method :success?

              ##
              # @return [Boolean]
              #
              abstract_method :failure?

              ##
              # @return [Boolean]
              #
              abstract_method :error?

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              abstract_method :each_step

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              abstract_method :each_evaluated_step

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveConnectedSteps::Entities::Expressions::Base]
              #
              abstract_method :with_organizer

              ##
              # @return [String]
              #
              abstract_method :inspect

              ##
              # @return [Boolean, nil]
              #
              abstract_method :==

              ##
              # @return [Boolean, nil]
              #
              abstract_method :to_arguments

              ##
              # @return [Boolean]
              #
              def scalar?
                false
              end

              ##
              # @return [Boolean]
              #
              def not?
                false
              end

              ##
              # @return [Boolean]
              #
              def and?
                false
              end

              ##
              # @return [Boolean]
              #
              def or?
                false
              end

              ##
              # @return [Boolean]
              #
              def group?
                false
              end

              ##
              # @return [Boolean]
              #
              def empty?
                false
              end
            end
          end
        end
      end
    end
  end
end
