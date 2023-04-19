# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module HasAroundCallbacks
        class Middleware < MethodChainMiddleware
          ##
          # @internal
          #   TODO: Move to command.
          #
          include Support::DependencyContainer::Import

          import :"entities.Callback", from: Common::Plugins::HasCallbacks::Container

          intended_for any_method, scope: any_scope

          def next(*args, **kwargs, &block)
            ##
            # A variable that stores return value of middleware `chain.next` aka `original_value`.
            # It is reassigned later by the `initial_around_callback`.
            #
            original_value = nil

            ##
            # A list of around callbacks.
            #
            # class Service
            #   around do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            # end
            #
            # class Service
            #   around do |chain, arguments|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            # end
            #
            around_callbacks = entity.callbacks.for([:around, method])

            ##
            #
            #
            initial_around_callback = entities.Callback.new(
              types: [:around, method],
              block: proc { original_value = chain.next(*args, **kwargs, &block) }
            )

            ##
            # Let's suppose that we have 3 `around` callbacks:
            #
            # class Service
            #   # first
            #   around do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            #
            #   # second
            #   around do |chain|
            #     # part before `chain.yield`
            #     original_value = chain.yield
            #     # part after `chain.yield`
            #   end
            #
            #   # third
            #   around do |chain|
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
            raise Errors::AroundCallbackChainIsNotContinued.new(callback: Utils::Array.find_last(around_callbacks, &:called?)) if around_callbacks.any?(&:not_called?)

            ##
            #
            #
            raise Errors::AroundCallbackChainIsNotContinued.new(callback: around_callbacks.last) if initial_around_callback.not_called?

            original_value
          end
        end
      end
    end
  end
end
