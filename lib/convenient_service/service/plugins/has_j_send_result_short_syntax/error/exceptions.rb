# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Error
          module Exceptions
            class BothArgsAndKwargsArePassed < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize_without_arguments
                message = <<~TEXT
                  Both `args` and `kwargs` are passed to the `error` method.

                  Did you mean something like:

                  error("Helpful text")
                  error("Helpful text", :descriptive_code)

                  error(message: "Helpful text")
                  error(message: "Helpful text", code: :descriptive_code)
                TEXT

                initialize(message)
              end
            end

            class KwargsContainJSendAndExtraKeys < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize_without_arguments
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

                initialize(message)
              end
            end

            class MoreThanTwoArgsArePassed < ::ConvenientService::Exception
              def initialize_without_arguments
                message = <<~TEXT
                  More than two `args` are passed to the `error` method.

                  Did you mean something like:

                  error("Helpful text")
                  error("Helpful text", :descriptive_code)
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
