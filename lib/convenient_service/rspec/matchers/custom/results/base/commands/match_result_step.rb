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
                  service_step = Commands::FindResultServiceStep.call(result: result, service_class: step)

                  Utils.to_bool(service_step)
                end

                ##
                # @return [Boolean]
                #
                def match_result_method_step?
                  result_method_step = Commands::FindResultResultMethodStep.call(result: result)

                  Utils.to_bool(result_method_step)
                end

                ##
                # @return [Boolean]
                #
                def match_method_step?
                  method_step = Commands::FindResultMethodStep.call(result: result, method_name: step)

                  Utils.to_bool(method_step)
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
