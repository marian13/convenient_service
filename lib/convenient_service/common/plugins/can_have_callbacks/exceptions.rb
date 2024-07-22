# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        module Exceptions
          class AroundCallbackChainIsNotContinued < ::ConvenientService::Exception
            ##
            # @param callback [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::Callback]
            # @return [void]
            #
            # @internal
            #   TODO: `around :#{method} do |chain|`.
            #
            def initialize_with_kwargs(callback:)
              message = <<~TEXT
                Around callback chain is NOT continued from `#{callback.source_location_joined_by_colon}`.

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
