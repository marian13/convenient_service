# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class IgnoringException < Support::Command
          module Exceptions
            class IgnoredExceptionIsNotRaised < ::ConvenientService::Exception
              ##
              # @param exception [StandardError]
              # @return [void]
              #
              def initialize(exception:)
                message = <<~TEXT
                  Exception `#{exception}` is NOT raised. That is why it is NOT ignored.
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
