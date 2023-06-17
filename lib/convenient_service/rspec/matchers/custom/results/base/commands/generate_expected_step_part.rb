# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Commands
              class GenerateExpectedStepPart < Support::Command
                ##
                # @!attribute [r] step
                #   @return [Class, Symbol]
                #
                attr_reader :step

                ##
                # @param step [Class, Symbol]
                # @return [void]
                #
                def initialize(step:)
                  @step = step
                end

                ##
                # @return [String]
                #
                def call
                  if step.nil?
                    "without step"
                  else
                    "of step `#{step}`"
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
