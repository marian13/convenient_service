# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAroundCallbacks
        module Errors
          class AroundCallbackChainIsNotContinued < ::ConvenientService::Exception
            def initialize(callback:)
              message = <<~TEXT
                Around callback chain is NOT continued from `#{callback.block.source_location}`.

                Did you forget to call `chain.yield`? For example:

                around :result do |chain|
                  # ...
                  chain.yield
                  # ...
                end
              TEXT

              super(message)
            end
          end
        end
      end
    end
  end
end
