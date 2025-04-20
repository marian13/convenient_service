# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallbacks
        module Exceptions
          class FallbackResultIsNotOverridden < ::ConvenientService::Exception
            def initialize_with_kwargs(service:, status:)
              message = <<~TEXT
                Fallback#{enclose(status, " ")}result method (#fallback#{enclose(status, "_")}result) of `#{service.class}` is NOT overridden.

                NOTE: Make sure overridden `fallback#{enclose(status, "_")}result` returns `success` with reasonable "null" data.
              TEXT

              initialize(message)
            end

            private

            ##
            # @return [String]
            #
            def enclose(...)
              ConvenientService::Utils::String.enclose(...)
            end
          end

          class ServiceFallbackReturnValueNotSuccess < ::ConvenientService::Exception
            def initialize_with_kwargs(service:, result:, status:)
              message = <<~TEXT
                Return value of service `#{service.class}`#{enclose(status, " ")}fallback is NOT a `success`.
                It is `#{result.status}`.

                Did you accidentally call `failure` or `error` instead of `success` from the `fallback#{enclose(status, "_")}result` method?
              TEXT

              initialize(message)
            end

            private

            ##
            # @return [String]
            #
            def enclose(...)
              ConvenientService::Utils::String.enclose(...)
            end
          end
        end
      end
    end
  end
end
