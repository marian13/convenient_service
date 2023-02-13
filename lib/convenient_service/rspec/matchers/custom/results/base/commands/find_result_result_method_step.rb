# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class FindResultResultMethodStep < Support::Command
                ##
                # @!attribute result [r]
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @return [void]
                #
                def initialize(result:)
                  @result = result
                end

                ##
                # @return [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method]
                #
                def call
                  return nil unless result.step

                  result.step.inputs.find { |input| match_service_class?(input) && match_key?(input) && match_value?(input) }
                end

                private

                ##
                # @param input [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method]
                # @return [Boolean]
                #
                def match_service_class?(input)
                  result.step.service_class == Services::RunOwnMethodInOrganizer
                end

                ##
                # @param input [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method]
                # @return [Boolean]
                #
                def match_key?(input)
                  input.key.to_sym == :method_name
                end

                ##
                # @param input [ConvenientService::Service::Plugins::HasResultSteps::Entities::Method]
                # @return [Boolean]
                #
                def match_value?(input)
                  input.value.to_sym == :result
                end
              end
            end
          end
        end
      end
    end
  end
end
