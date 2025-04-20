# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CollectsServicesInException
        module Commands
          class ExtractServiceDetails < Support::Command
            ##
            # @!attribute [r] service
            #   @return [ConvenientService::Service]
            #
            attr_reader :service

            ##
            # @!attribute [r] method
            #   @return [Symbol]
            #
            attr_reader :method

            ##
            # @param service [ConvenientService::Service]
            # @return [void]
            #
            def initialize(service:, method:)
              @service = service
              @method = method
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def call
              {instance: service, trigger: trigger}
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            # @internal
            #   PARANOID: `unless first_not_evaluated_step` is a paranoid code (probably `ConvenientService` bug).
            #   - https://encyclopedia2.thefreedictionary.com/paranoid+programming
            #   - https://dzone.com/articles/defensive-programming-just
            #
            def trigger
              return {method: ":#{method}"} if method != :result
              return {method: ":result"} if service.steps.none?
              return {step: "Unknown Step", index: -1} unless first_not_evaluated_step

              {step: first_not_evaluated_step.printable_action, index: first_not_evaluated_step.index}
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Step, nil]
            #
            def first_not_evaluated_step
              Utils.memoize_including_falsy_values(self, :@first_not_evaluated_step) { service.steps.find(&:not_evaluated?) }
            end
          end
        end
      end
    end
  end
end
