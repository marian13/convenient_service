# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class IgnoringError < Support::Command
          module Errors
            class IgnoredErrorIsNotRaised < ::ConvenientService::Error
              ##
              # @param error [Exception]
              # @return [void]
              #
              def initialize(error:)
                message = <<~TEXT
                  Error `#{error}` is NOT raised. That is why it is NOT ignored.
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