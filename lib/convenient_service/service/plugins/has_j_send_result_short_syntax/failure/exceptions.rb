# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Failure
          module Exceptions
            class KwargsContainNonJSendKey < ::ConvenientService::Exception
              def initialize(key:)
                message = <<~TEXT
                  When `kwargs` with `data` key are passed to `failure` method, they can NOT contain non JSend keys like `#{key.inspect}`.

                  Please, consider something like:

                  failure(foo: :bar) # short version does NOT support custom message
                  failure(data: {foo: :bar}) # long version
                  failure(data: {foo: :bar}, message: "foo") # long version with custom message
                TEXT

                super(message)
              end
            end
          end
        end
      end
    end
  end
end
