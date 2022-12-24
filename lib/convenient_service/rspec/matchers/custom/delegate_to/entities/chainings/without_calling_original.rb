# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            module Chainings
              class WithoutCallingOriginal < Chainings::Base
                ##
                # @param block_expectation_value [Object]
                # @return [Boolean]
                #
                def matches?(block_expectation_value)
                  super

                  true
                end

                ##
                # @return [Boolean]
                #
                def should_call_original?
                  false
                end
              end
            end
          end
        end
      end
    end
  end
end
