# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Constants
              module Triggers
                ##
                # @return [ConvenientService::Support::UniqueValue]
                #
                BE_RESULT = Support::UniqueValue.new("BE_RESULT")
              end

              ##
              # @return [Symbol]
              #
              DEFAULT_COMPARISON_METHOD = :==
            end
          end
        end
      end
    end
  end
end
