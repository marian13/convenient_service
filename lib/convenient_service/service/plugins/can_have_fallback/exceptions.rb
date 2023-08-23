# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveFallback
        module Exceptions
          class FallbackResultIsNotOverridden < ::ConvenientService::Exception
            def initialize(service:)
              message = <<~TEXT
                Fallback result method (#fallback_result) of `#{service.class}` is NOT overridden.

                NOTE: Make sure overridden `fallback_result` returns `success` with reasonable "null" data.
              TEXT

              super(message)
            end
          end

          class ServiceFallbackReturnValueNotSuccess < ::ConvenientService::Exception
            def initialize(service:, result:)
              message = <<~TEXT
                Return value of service `#{service.class}` try is NOT a `success`.
                It is `#{result.status}`.

                Did you accidentally call `failure` or `error` instead of `success` from the `fallback_result` method?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
