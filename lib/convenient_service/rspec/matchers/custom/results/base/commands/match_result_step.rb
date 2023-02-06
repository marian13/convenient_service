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
                # @!attribute result [r]
                #   @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                #
                attr_reader :result

                ##
                # @!attribute step [r]
                #   @return [Class, Symbol]
                #
                attr_reader :step

                ##
                # @param result [ConvenientService::Service::Plugins::HasResult::Entities::Result]
                # @param step [Class, Symbol]
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
                def call
                  case step
                  when ::Class
                    match_result_service_step
                  when ::Symbol
                    match_method_step
                  when nil
                    match_without_step
                  else
                    raise Errors::InvalidStep.new(step: step)
                  end
                end

                private

                ##
                # @return [Boolean]
                #
                def match_result_service_step
                  return false if result.step.nil?

                  result.step.service.klass == step
                end

                ##
                # @return [Boolean]
                #
                def match_method_step
                  return false if result.step.nil?

                  ##
                  # TODO: Move to step.
                  #
                  input = result.step.inputs.find { |input| input.key.to_sym == :method_name }

                  return false unless input

                  input.value == step
                end

                ##
                # @return [Boolean]
                #
                def match_without_step
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
