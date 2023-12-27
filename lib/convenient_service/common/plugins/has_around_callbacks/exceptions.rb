# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAroundCallbacks
        module Exceptions
          class AroundCallbackChainIsNotContinued < ::ConvenientService::Exception
            def initialize_with_kwargs(callback:)
              message = <<~TEXT
                Around callback chain is NOT continued from `#{callback.block.source_location}`.

                Did you forget to call `chain.yield`? For example:

                around :result do |chain|
                  # ...
                  chain.yield
                  # ...
                end
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
