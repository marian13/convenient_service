# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveHelpers
      module Classes
        class IgnoringException < Support::Command
          module Exceptions
            class IgnoredExceptionIsNotRaised < ::ConvenientService::Exception
              ##
              # @param exception [StandardError]
              # @return [void]
              #
              def initialize_with_kwargs(exception:)
                message = <<~TEXT
                  Exception `#{exception}` is NOT raised. That is why it is NOT ignored.
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
