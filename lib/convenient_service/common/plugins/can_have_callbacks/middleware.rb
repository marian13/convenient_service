# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module CanHaveCallbacks
        class Middleware < MethodChainMiddleware
          ##
          # @internal
          #   TODO: Support of callbacks for class methods.
          #
          intended_for any_method, entity: any_entity

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [Object] Can be any type.
          #
          # @internal
          #   TODO: Move to command.
          #
          def next(*args, **kwargs, &block)
            run_before_callbacks(*args, **kwargs, &block)

            original_value = run_around_callbacks(*args, **kwargs, &block)

            run_after_callbacks(original_value, *args, **kwargs, &block)

            original_value
          end

          private

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [void]
          #
          # @example Before callbacks.
          #   class Service
          #     before :result do
          #     end
          #
          #     before :result do |arguments|
          #     end
          #   end
          #
          def run_before_callbacks(*args, **kwargs, &block)
            callbacks.for([:before, method]).each { |callback| callback.call_in_context_with_arguments(entity, *args, **kwargs, &block) }
          end

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [Object] Can be any type.
          #
          # @example After callbacks.
          #   class Service
          #     after :result do
          #     end
          #
          #     after :result do |result|
          #     end
          #
          #     after :result do |result, arguments|
          #     end
          #   end
          #
          def run_after_callbacks(original_value, *args, **kwargs, &block)
            callbacks.for([:after, method]).reverse_each { |callback| callback.call_in_context_with_value_and_arguments(entity, original_value, *args, **kwargs, &block) }
          end

          ##
          # @param args [Array<Object>]
          # @param kwargs [Hash{Symbol => Object}]
          # @param block [Proc, nil]
          # @return [Object] Can be any type.
          #
          # @example Around callbacks.
          #   class Service
          #     around :result do |chain|
          #       # part before `chain.yield`
          #       original_value = chain.yield
          #       # part after `chain.yield`
          #     end
          #
          #     around :result do |chain, arguments|
          #       # part before `chain.yield`
          #       original_value = chain.yield
          #       # part after `chain.yield`
          #     end
          #   end
          #
          def run_around_callbacks(*args, **kwargs, &block)
            ##
            # A variable that stores return value of middleware `chain.next` aka `original_value`.
            # It is reassigned later by the `initial_around_callback`.
            #
            original_value = nil

            ##
            # A list of around callbacks.
            #
            # class Service
            #   around :result do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            # end
            #
            # class Service
            #   around :result do |chain, arguments|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            # end
            #
            around_callbacks = callbacks.for([:around, method])

            ##
            #
            #
            initial_around_callback = Entities::Callback.new(
              types: [:around, method],
              block: proc { original_value = chain.next(*args, **kwargs, &block) }
            )

            ##
            # Let's suppose that we have 3 `around` callbacks:
            #
            # class Service
            #   # first
            #   around :result do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            #
            #   # second
            #   around :result do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            #
            #   # third
            #   around :result do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            # end
            #
            # NOTE: if a user forgets to call `chain.yield` - an error is raised.
            #
            # Then `composed` may be built with the following preudocode (that is why `reverse` is needed):
            #
            #   composed = original
            #   composed = proc { instance_exec(composed, &third) }
            #   composed = proc { instance_exec(composed, &second) }
            #   composed = proc { instance_exec(composed, &first) }
            #
            # Where `first`, `second`, `third` are taken from `entity.callbacks.for([:around, method])`.
            #
            # Original implementation is modified in order to return `original_value` from all `chain.yield` calls.
            #
            #   # Original implementation:
            #   composed =
            #     callbacks.for([:around, method]).reverse.reduce(original) do |composed, callback|
            #       proc { instance_exec(composed, &callback) }
            #     end
            #
            # Original implementation is modified for the second time in order to raise an error
            # if a user forgets to call `chain.yield` inside an around callback.
            #
            # rubocop:disable Style/Semicolon
            composed =
              around_callbacks.reverse.reduce(initial_around_callback) do |composed, callback|
                proc { callback.call_in_context_with_value_and_arguments(entity, composed, *args, **kwargs, &block); original_value }
              end
            # rubocop:enable Style/Semicolon

            ##
            # Call sequence:
            #
            #   composed.call
            #   proc { instance_exec(composed, &first) }.call  # part before `chain.yield`
            #   proc { instance_exec(composed, &second) }.call # part before `chain.yield`
            #   proc { instance_exec(composed, &third) }.call  # part before `chain.yield`
            #   initial_around_callback
            #   proc { instance_exec(composed, &third) }.call  # part after `chain.yield`
            #   proc { instance_exec(composed, &second) }.call # part after `chain.yield`
            #   proc { instance_exec(composed, &first) }.call  # part after `chain.yield`
            #
            composed.call

            ##
            #
            #
            ::ConvenientService.raise Exceptions::AroundCallbackChainIsNotContinued.new(callback: Utils::Array.find_last(around_callbacks, &:called?)) if around_callbacks.any?(&:not_called?)

            ##
            #
            #
            ::ConvenientService.raise Exceptions::AroundCallbackChainIsNotContinued.new(callback: around_callbacks.last) if initial_around_callback.not_called?

            original_value
          end

          ##
          # @return [ConvenientService::Common::Plugins::CanHaveCallbacks::Entities::CallbackCollection]
          #
          def callbacks
            @callbacks ||= entity.class.callbacks
          end
        end
      end
    end
  end
end
