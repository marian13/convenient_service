# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Success
          module Errors
            class KwargsContainDataAndExtraKeys < ::ConvenientService::Error
              def initialize
                message = <<~TEXT
                  `kwargs' passed to `success' method contain `data' and extra keys. That's NOT allowed.

                  Please, consider something like:

                  success(foo: :bar)
                  success(data: {foo: :bar})
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
