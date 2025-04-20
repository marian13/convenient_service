# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
