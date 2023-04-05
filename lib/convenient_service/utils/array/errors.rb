# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      module Errors
        class NonIntegerIndex < ::ConvenientService::Error
          def initialize(index:)
            message = <<~TEXT
              Index `#{index.inspect}` is NOT an integer.
            TEXT

            super(message)
          end
        end
      end
    end
  end
end
