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
        end
      end
    end
  end
end
