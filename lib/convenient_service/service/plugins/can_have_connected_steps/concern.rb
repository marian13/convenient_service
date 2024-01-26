# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            #
            # Registers a negated step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def not_step(*args, **kwargs)
              steps.register(*args, **kwargs.merge(negated: true))
            end

            ##
            # @api public
            #
            # Registers a step (step definition). Alias for `step`.
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def and_step(*args, **kwargs)
              steps.register(*args, **kwargs)
            end

            ##
            # @api public
            #
            # Registers a negated step (step definition). Alias for `not_step`.
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def and_not_step(*args, **kwargs)
              steps.register(*args, **kwargs.merge(negated: true))
            end
          end
        end
      end
    end
  end
end
