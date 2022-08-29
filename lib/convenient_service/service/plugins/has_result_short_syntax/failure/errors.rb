# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultShortSyntax
        module Failure
          module Errors
            class KwargsContainDataAndExtraKeys < ::ConvenientService::Error
              def initialize
                message = <<~TEXT
                  `kwargs' passed to `failure' method contain `data' and extra keys. That's NOT allowed.

                  Please, consider something like:

                  failure(foo: :bar)
                  failure(data: {foo: :bar})
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
