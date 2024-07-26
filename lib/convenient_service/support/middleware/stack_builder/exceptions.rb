# frozen_string_literal: true

module ConvenientService
  module Support
    module Middleware
      class StackBuilder
        module Exceptions
          class NotSupportedBackend < ::ConvenientService::Exception
            ##
            # @param backend [Symbol]
            # @return [void]
            #
            def initialize_with_kwargs(backend:)
              message = <<~TEXT
                Middleware backend `#{backend.inspect}` is NOT supported.

                Supported backends are #{printable_backends}.
              TEXT

              initialize(message)
            end

            private

            ##
            # @return [String]
            #
            def printable_backends
              Constants::Backends::ALL.map { |backend| "`#{backend.inspect}`" }.join(", ")
            end
          end
        end
      end
    end
  end
end
