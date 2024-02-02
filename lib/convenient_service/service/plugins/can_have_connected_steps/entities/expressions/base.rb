# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Entities
          module Expressions
            class Base
              include Support::AbstractMethod

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
            end
          end
        end
      end
    end
  end
end
