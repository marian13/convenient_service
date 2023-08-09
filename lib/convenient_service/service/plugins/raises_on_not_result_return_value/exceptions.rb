# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RaisesOnNotResultReturnValue
        module Exceptions
          class ReturnValueNotKindOfResult < ::ConvenientService::Exception
            def initialize(service:, result:, method:)
              message = <<~TEXT
                Return value of service `#{service.class}` is NOT a `Result`.
                It is `#{result.class}`.

                Did you forget to call `success`, `failure`, or `error` from the `:#{method}` method?
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
