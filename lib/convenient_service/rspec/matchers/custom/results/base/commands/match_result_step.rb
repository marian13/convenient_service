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
                  result.step&.service&.klass == step
                end
              end
            end
          end
        end
      end
    end
  end
end
