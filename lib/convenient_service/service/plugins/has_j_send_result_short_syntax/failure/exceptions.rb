# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Failure
          module Exceptions
            class KwargsContainJSendAndExtraKeys < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize_without_arguments
                message = <<~TEXT
                  `kwargs` passed to `failure` method contain JSend keys and extra keys. That's NOT allowed.

                  Please, consider something like:

                  # Shorter form with one arg. Assumes that arg is `message`.
                  failure("foo")

                  # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                  failure("foo", :foo)

                  # Shorter form with kwargs. Assumes that all kwargs are `data`.
                  failure(foo: :bar)

                  # Longer form. More explicit `message`.
                  failure(message: "foo")

                  # Longer form. More explicit `code`.
                  failure(code: :foo)

                  # Longer form. More explicit `message` and `code` together.
                  failure(message: "foo", code: :foo)

                  # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                  failure(data: {foo: :bar}, message: "foo")
                  failure(data: {foo: :bar}, code: :foo)
                  failure(data: {foo: :bar}, message: "foo", code: :foo)
                TEXT

                initialize(message)
              end
            end

            class BothArgsAndKwargsArePassed < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize_without_arguments
                message = <<~TEXT
                  Both `args` and `kwargs` are passed to the `failure` method.

                  Did you mean something like:

                  failure("Helpful text")
                  failure("Helpful text", :descriptive_code)

                  failure(message: "Helpful text")
                  failure(message: "Helpful text", code: :descriptive_code)
                TEXT

                initialize(message)
              end
            end

            class MoreThanTwoArgsArePassed < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize_without_arguments
                message = <<~TEXT
                  More than two `args` are passed to the `failure` method.

                  Did you mean something like:

                  failure("Helpful text")
                  failure("Helpful text", :descriptive_code)
                TEXT

                initialize(message)
              end
            end
          end
        end
      end
    end
  end
end
