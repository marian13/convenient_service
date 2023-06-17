# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class GenerateGotStepPart < Support::Command
                ##
                # @!attribute [r] result
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
                # @return [String]
                #
                def call
                  if result.step.nil?
                    "without step"
                  else
                    "of step `#{result.step.printable_service}`"
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
