# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Success
          module Exceptions
            class KwargsContainJSendAndExtraKeys < ::ConvenientService::Exception
              ##
              # @return [void]
              #
              def initialize_without_arguments
                message = <<~TEXT
                  `kwargs` passed to `success` method contain JSend keys and extra keys. That's NOT allowed.

                  Please, consider something like:

                  # Shorter form. Assumes that all kwargs are `data`.
                  success(foo: :bar)

                  # Longer form. More explicit.
                  success(data: {foo: :bar})

                  # (Advanced) Longer form also supports any other variation of `data`, `message` and `code`...
                  success(data: {foo: :bar}, message: "foo")
                  success(data: {foo: :bar}, code: :foo)
                  success(data: {foo: :bar}, message: "foo", code: :foo)
                  success(message: "foo")
                  success(code: :foo)
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
