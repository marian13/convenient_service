# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class MatchResultStep < Support::Command
                attr_reader :result

                attr_reader :step

                def initialize(result:, step:)
                  @result = result
                  @step = step
                end

                def call
                  return false if result.step.nil?

                  case step
                  when ::Class
                    match_result_service_step
                  when ::Symbol
                    match_method_step
                  else
                    raise Errors::InvalidStep.new(step: step)
                  end
                end

                private

                def match_result_service_step
                  result.step.service.klass == step
                end

                def match_method_step
                  input = result.step.inputs.find { |input| input.key.to_sym == :method_name }

                  return false unless input

                  input.value == step
                end
              end
            end
          end
        end
      end
    end
  end
end
