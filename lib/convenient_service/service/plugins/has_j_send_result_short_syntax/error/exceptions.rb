# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Error
          module Exceptions
            class KwargsContainJSendAndExtraKeys < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize
                message = <<~TEXT
                  `kwargs` passed to `error` method contain JSend keys and extra keys. That's NOT allowed.

                  Please, consider something like:

                  # Shorter form with one arg. Assumes that arg is `message`.
                  error("foo")

                  # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                  error("foo", :foo)

                  # Shorter form with kwargs. Assumes that all kwargs are `data`.
                  error(foo: :bar)

                  # Longer form. More explicit `message`.
                  error(message: "foo")

                  # Longer form. More explicit `code`.
                  error(code: :foo)

                  # Longer form. More explicit `message` and `code` together.
                  error(message: "foo", code: :foo)

                  # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                  error(data: {foo: :bar}, message: "foo")
                  error(data: {foo: :bar}, code: :foo)
                  error(data: {foo: :bar}, message: "foo", code: :foo)
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
