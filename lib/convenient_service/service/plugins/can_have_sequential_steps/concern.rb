# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveSequentialSteps
        module Concern
          include Support::Concern

          class_methods do
            ##
            # @api public
            #
            # Registers a step (step definition).
            #
            # @param args [Array<Object>]
            # @param kwargs [Hash{Symbol => Object}]
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step]
            #
            def step(*args, **kwargs)
              steps.create(*args, **kwargs)
            end

            ##
            # @api private
            #
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::StepCollection]
            #
            def steps
              internals_class.cache.fetch(:steps) { Entities::StepCollection.new(container: self) }
            end
          end

          instance_methods do
            ##
            # @api public
            #
            # @note May be useful for debugging purposes.
            # @see https://userdocs.convenientservice.org/guides/how_to_debug_services_via_callbacks
            #
            # @note `steps` are frozen.
            # @see https://userdocs.convenientservice.org/faq#is-it-possible-to-modify-the-step-collection-from-a-callback
            #
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::StepСollection]
            #
            def steps
              internals.cache.fetch(:steps) do
                self.class
                  .steps
                  .tap(&:commit!)
                  .with_organizer(self)
                  .tap(&:commit!)
              end
            end
          end
        end
      end
    end
  end
end
