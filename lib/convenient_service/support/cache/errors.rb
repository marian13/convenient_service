# frozen_string_literal: true

module ConvenientService
  module Support
    class Cache
      module Errors
        class NotSupportedBackend < ::ConvenientService::Error
          ##
          # @param backend [Symbol]
          # @return [void]
          #
          def initialize(backend:)
            message = <<~TEXT
              Backend `#{backend}` is NOT supported.

              Supported backends are #{printable_backends}.
            TEXT

            super(message)
          end

          private

          ##
          # @return [String]
          #
          def printable_backends
            Constants::Backends::ALL.map { |backend| "`:#{backend}`" }.join(", ")
          end
        end
      end
    end
  end
end