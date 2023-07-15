# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultStep < Support::Command
                ##
                # @!attribute [r] result
                #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute [r] step
                #   @return [ConvenientService::Service, Symbol]
                #
                attr_reader :step

                ##
                # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
                # @param step [ConvenientService::Service, Symbol]
                # @return [void]
                #
                def initialize(result:, step:)
                  @result = result
                  @step = step
                end

                ##
                # @return [Boolean]
                # @raise [ConvenientService::RSpec::Matchers::Custom::Results::Base::Errors::InvalidStep]
                #
                # @internal
                #   TODO: Import via commands.
                #
                def call
                  case step
                  when ::Class then match_service_step?
                  when :result then match_result_method_step?
                  when ::Symbol then match_method_step?
                  when nil then match_without_step?
                  else raise Errors::InvalidStep.new(step: step)
                  end
                end

                private

                ##
                # @return [Boolean]
                #
                def match_service_step?
                  return false unless result.step

                  result.step.service_class == step
                end

                ##
                # @return [Boolean]
                #
                def match_result_method_step?
                  return false unless result.step

                  result.step.result_step?
                end

                ##
                # @return [Boolean]
                #
                def match_method_step?
                  return false unless result.step&.method_step?

                  result.step.method.to_sym == step
                end

                ##
                # @return [Boolean]
                #
                def match_without_step?
                  result.step.nil?
                end
              end
            end
          end
        end
      end
    end
  end
end
