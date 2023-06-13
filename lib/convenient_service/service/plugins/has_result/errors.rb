# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResult
        module Errors
          class ResultIsNotOverridden < ::ConvenientService::Error
            def initialize(service:)
              message = <<~TEXT
                Result method (#result) of `#{service.class}` is NOT overridden.
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
