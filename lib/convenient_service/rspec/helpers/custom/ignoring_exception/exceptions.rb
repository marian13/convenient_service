# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Helpers
      module Custom
        class IgnoringException < Support::Command
          module Exceptions
            class IgnoredErrorIsNotRaised < ::ConvenientService::Exception
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
