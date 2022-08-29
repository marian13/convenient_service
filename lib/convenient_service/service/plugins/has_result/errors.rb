# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Errors
          class ResultIsNotOverridden < ConvenientService::Error
            def initialize(service:)
              message = <<~TEXT
                Result method (#result) of `#{service.class}' is NOT overridden.
              TEXT

              super(message)
            end
          end

          class ServiceReturnValueNotKindOfResult < ConvenientService::Error
            def initialize(service:, result:)
              message = <<~TEXT
                Return value of service `#{service.class}' is NOT a `Result'.
                It is a `#{result.class}'.

                Did you forget to call `success', `failure', or `error' from the `result' method?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
