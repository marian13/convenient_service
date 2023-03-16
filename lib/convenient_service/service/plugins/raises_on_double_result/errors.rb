# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module RaisesOnDoubleResult
        module Errors
          class DoubleResult < ::ConvenientService::Error
            def initialize(service:)
              message = <<~TEXT
                `#{service.class}` service has a double result.

                Make sure its #result calls only one from the following methods `success`, `failure`, or `error` and only once.

                Maybe you missed `return`? The most common scenario is similar to this one:

                def result
                  # ...

                  error unless valid?
                  # instead of return error unless valid?

                  success
                end
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
