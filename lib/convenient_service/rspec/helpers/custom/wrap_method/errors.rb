# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class WrapMethod < Support::Command
          module Errors
            class ChainAttributePreliminaryAccess < ConvenientService::Error
              ##
              # @param attribute [Symbol]
              # @return [void]
              #
              def initialize(attribute:)
                message = <<~TEXT
                  Chain attribute `#{attribute}` is accessed before the chain is called.
                TEXT

                super(message)
              end
            end
          end
        end
      end
    end
  end
end
