# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Classes
        class WrapMethod < Support::Command
          module Exceptions
            class ChainAttributePreliminaryAccess < ::ConvenientService::Exception
              ##
              # @param attribute [Symbol]
              # @return [void]
              #
              def initialize_with_kwargs(attribute:)
                message = <<~TEXT
                  Chain attribute `#{attribute}` is accessed before the chain is called.
                TEXT

                initialize(message)
              end
            end
          end
        end
      end
    end
  end
end
