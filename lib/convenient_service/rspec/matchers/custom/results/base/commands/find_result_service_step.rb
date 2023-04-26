# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class FindResultServiceStep < Support::Command
                ##
                # @!attribute result [r]
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute service_class [r]
                #   @return [Class]
                #
                attr_reader :service_class

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @param service_class [Class]
                # @return [void]
                #
                def initialize(result:, service_class:)
                  @result = result
                  @service_class = service_class
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                #
                def call
                  return nil unless result.step

                  result.step.service_class == service_class
                end
              end
            end
          end
        end
      end
    end
  end
end
