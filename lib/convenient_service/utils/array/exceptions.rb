# frozen_string_literal: true

module ConvenientService
  module Utils
    module Array
      module Exceptions
        class NonIntegerIndex < ::ConvenientService::Exception
          def initialize_with_kwargs(index:)
            message = <<~TEXT
              Index `#{index.inspect}` is NOT an integer.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
