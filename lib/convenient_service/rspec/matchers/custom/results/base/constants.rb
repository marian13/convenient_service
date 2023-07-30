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
                # @api private
                #
                # @return [ConvenientService::Support::UniqueValue]
                #
                BE_RESULT = Support::UniqueValue.new("BE_RESULT")
              end

              ##
              # @api private
              #
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
