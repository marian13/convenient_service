# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Exceptions
          class KwargsContainJSendAndExtraKeys < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_with_kwargs(status:)
              message = <<~TEXT
                `kwargs` passed to `#{status}` method contain JSend keys and extra keys. That's NOT allowed.

                Please, consider something like:

                # Shorter form. Assumes that all kwargs are `data`.
                #{status}(foo: :bar)

                # Shorter form with one arg. Assumes that arg is `message`.
                #{status}("foo")

                # Shorter form with two args. Assumes that first arg is `message` and second is `code`.
                #{status}("foo", :foo)

                # Longer form. More explicit `data`.
                #{status}(data: {foo: :bar})

                # Longer form. More explicit `message`.
                #{status}(message: "foo")

                # Longer form. More explicit `code`.
                #{status}(code: :foo)

                # Longer form. More explicit `message` and `code` together.
                #{status}(message: "foo", code: :foo)

                # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`.
                #{status}(data: {foo: :bar}, message: "foo")
                #{status}(data: {foo: :bar}, code: :foo)
                #{status}(data: {foo: :bar}, message: "foo", code: :foo)
              TEXT

              initialize(message)
            end
          end

          class BothArgsAndKwargsArePassed < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_with_kwargs(status:)
              message = <<~TEXT
                Both `args` and `kwargs` are passed to the `#{status}` method.

                Did you mean something like:

                #{status}("Helpful text")
                #{status}("Helpful text", :descriptive_code)

                #{status}(message: "Helpful text")
                #{status}(message: "Helpful text", code: :descriptive_code)
              TEXT

              initialize(message)
            end
          end

          class MoreThanTwoArgsArePassed < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_with_kwargs(status:)
              message = <<~TEXT
                More than two `args` are passed to the `#{status}` method.

                Did you mean something like:

                #{status}("Helpful text")
                #{status}("Helpful text", :descriptive_code)
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
