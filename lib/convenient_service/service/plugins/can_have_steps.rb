# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

require_relative "can_have_steps/commands"
require_relative "can_have_steps/concern"
require_relative "can_have_steps/entities"
require_relative "can_have_steps/middleware"

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        class << self
          ##
          # Checks whether an object is a step instance.
          #
          # @api public
          #
          # @param step [Object] Can be any type.
          # @return [Boolean]
          #
          # @example Simple usage.
          #   class Service
          #     include ConvenientService::Standard::Config
          #
          #     step :result
          #
          #     def result
          #       success
          #     end
          #   end
          #
          #   step = Service.new.steps.first
          #
          #   ConvenientService::Plugins::Service::CanHaveSteps.step?(step)
          #   # => true
          #
          #   ConvenientService::Plugins::Service::CanHaveSteps.step?(42)
          #   # => false
          #
          def step?(step)
            Commands::IsStep[step: step]
          end
        end
      end
    end
  end
end
