# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

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
            # They are wrapped by Ruby hashes in order to have a way to track whether they were called.
            # That is needed to raise a self-explanatory exception when any around callback misses to call the next callback in a sequence.
            # See specs for examples and more details.
            #
            around_callbacks = callbacks.for([:around, method]).map do |callback_object|
              {
                object: callback_object,
                called: false
              }
            end

            ##
            # So-called initial callback is required to track whether the last around callback in a sequence is called.
            # See specs for examples and more details.
            #
            initial_around_callback = {
              object: Entities::Callback.new(
                types: [:around, method],
                block: proc do
                  original_value = chain.next(*args, **kwargs, &block)

                  initial_around_callback[:called] = true

                  original_value
                end
              ),
              called: false
            }

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
            # NOTE: if a user forgets to call `chain.yield` - an exception is raised.
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
            # Original implementation is modified for the second time in order to raise an exception
            # if a user forgets to call `chain.yield` inside an around callback.
            #
            composed =
              around_callbacks.reverse_each.reduce(initial_around_callback[:object]) do |composed, callback|
                proc do
                  callback[:object].call_in_context_with_value_and_arguments(entity, composed, *args, **kwargs, &block)

                  callback[:called] = true

                  original_value
                end
              end

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
            # Raised when any intermediate around callback does NOT call `chain.yield`.
            #
            #   around :result do |chain|
            #     puts "first around before result"
            #
            #     chain.yield
            #
            #     puts "first around after result"
            #   end
            #
            #   around :result do |chain|
            #     puts "second around before result"
            #
            #     puts "second around after result"
            #   end
            #
            #   around :result do |chain|
            #     puts "third around before result"
            #
            #     chain.yield
            #
            #     puts "third around after result"
            #   end
            #
            if around_callbacks.any? { |callback| !callback[:called] }
              last_called_callback = Utils::Array.find_last(around_callbacks) { |callback| callback[:called] }

              ::ConvenientService.raise Exceptions::AroundCallbackChainIsNotContinued.new(callback: last_called_callback[:object])
            end

            ##
            # Raised when the last around callback does NOT call `chain.yield`.
            #
            #   around :result do |chain|
            #     puts "first around before result"
            #
            #     chain.yield
            #
            #     puts "first around after result"
            #   end
            #
            #   around :result do |chain|
            #     puts "second around before result"
            #
            #     puts "second around after result"
            #   end
            #
            if !initial_around_callback[:called]
              ::ConvenientService.raise Exceptions::AroundCallbackChainIsNotContinued.new(callback: around_callbacks.last[:object])
            end

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
