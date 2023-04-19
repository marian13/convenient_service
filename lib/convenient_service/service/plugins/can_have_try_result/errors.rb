# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveTryResult
        module Errors
          class TryResultIsNotOverridden < ::ConvenientService::Error
            def initialize(service:)
              message = <<~TEXT
                Try result method (#try_result) of `#{service.class}` is NOT overridden.

                NOTE: Make sure overridden `try_result` returns `success` with reasonable "null" data.
              TEXT

              super(message)
            end
          end

          class ServiceTryReturnValueNotKindOfResult < ::ConvenientService::Error
            def initialize(service:, result:)
              message = <<~TEXT
                Return value of service `#{service.class}` try is NOT a `Result`.
                It is `#{result.class}`.

                Did you forget to call `success` from the `try_result` method?
              TEXT

              super(message)
            end
          end

          class ServiceTryReturnValueNotSuccess < ::ConvenientService::Error
            def initialize(service:, result:)
              message = <<~TEXT
                Return value of service `#{service.class}` try is NOT a `success`.
                It is `#{result.status}`.

                Did you accidentally call `failure` or `error` instead of `success` from the `try_result` method?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
