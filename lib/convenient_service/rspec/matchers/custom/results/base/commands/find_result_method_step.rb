# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class FindResultMethodStep < Support::Command
                ##
                # @!attribute result [r]
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute method_name [r]
                #   @return [Symbol]
                #
                attr_reader :method_name

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @param method_name [Symbol]
                # @return [void]
                #
                def initialize(result:, method_name:)
                  @result = result
                  @method_name = method_name
                end

                ##
                # @return [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                #
                def call
                  return nil unless result.step

                  result.step.inputs.find { |input| match_service_class?(input) && match_key?(input) && match_value?(input) }
                end

                private

                ##
                # @param input [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @return [Boolean]
                #
                def match_service_class?(input)
                  result.step.service_class == Services::RunMethodInOrganizer
                end

                ##
                # @param input [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @return [Boolean]
                #
                def match_key?(input)
                  input.key.to_sym == :method_name
                end

                ##
                # @param input [ConvenientService::Service::Plugins::CanHaveSteps::Entities::Method]
                # @return [Boolean]
                #
                def match_value?(input)
                  input.value.to_sym == method_name
                end
              end
            end
          end
        end
      end
    end
  end
end
