# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultService < Support::Command
                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute [r] service_class
                #   @return [ConvenientService::Service]
                #
                attr_reader :service_class

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @param service_class [ConvenientService::Service]
                # @return [void]
                #
                def initialize(result:, service_class:)
                  @result = result
                  @service_class = service_class
                end

                ##
                # @return [Boolean]
                #
                def call
                  result.service.instance_of?(service_class)
                end
              end
            end
          end
        end
      end
    end
  end
end
