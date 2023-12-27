# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResult
        module Exceptions
          class ResultIsNotOverridden < ::ConvenientService::Exception
            def initialize_with_kwargs(service:)
              message = <<~TEXT
                Result method (#result) of `#{service.class}` is NOT overridden.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
