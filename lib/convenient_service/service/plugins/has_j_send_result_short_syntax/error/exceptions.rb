# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultShortSyntax
        module Error
          module Exceptions
            class BothArgsAndKwargsArePassed < ::ConvenientService::Exception
              def initialize
                message = <<~TEXT
                  Both `args` and `kwargs` are passed to the `error` method.

                  Did you mean something like:

                  error("Helpful text")
                  error("Helpful text", :descriptive_code)

                  error(message: "Helpful text")
                  error(message: "Helpful text", code: :descriptive_code)
                TEXT

                super(message)
              end
            end

            class MoreThanTwoArgsArePassed < ::ConvenientService::Exception
              def initialize
                message = <<~TEXT
                  More than two `args` are passed to the `error` method.

                  Did you mean something like:

                  error("Helpful text")
                  error("Helpful text", :descriptive_code)
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
