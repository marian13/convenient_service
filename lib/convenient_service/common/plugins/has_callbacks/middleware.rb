# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasCallbacks
        class Middleware < Core::MethodChainMiddleware
          def next(*args, **kwargs, &block)
            ##
            # class Service
            #   before :result do
            #   end
            #
            #   before :result do |arguments|
            #   end
            # end
            #
            entity.callbacks.for([:before, method]).each { |callback| callback.call_in_context_with_arguments(entity, *args, **kwargs, &block) }

            original_value = chain.next(*args, **kwargs, &block)

            ##
            # class Service
            #   after :result do
            #   end
            #
            #   after :result do |result|
            #   end
            #
            #   after :result do |result, arguments|
            #   end
            # end
            #
            entity.callbacks.for([:after, method]).reverse_each { |callback| callback.call_in_context_with_value_and_arguments(entity, original_value, *args, **kwargs, &block) }

            original_value
          end
        end
      end
    end
  end
end
