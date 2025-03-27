# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Commands
          class CastStepAwareEnumerator < Support::Command
            ##
            # @return [Hash{Class => Class}]
            #
            RUBY_CLASS_TO_STEP_AWARE_CLASS_MAP = {
              ::Enumerator => Entities::StepAwareEnumerables::Enumerator,
              ::Enumerator::Lazy => Entities::StepAwareEnumerables::LazyEnumerator,
              ::Enumerator::Chain => Entities::StepAwareEnumerables::ChainEnumerator,
              ::Enumerator::ArithmeticSequence => Entities::StepAwareEnumerables::ArithmeticSequenceEnumerator
            }

            ##
            # @!attribute [r] object
            #   @return [Object] Can be any type.
            #
            attr_reader :object

            ##
            # @!attribute [r] organizer
            #   @return [ConvenientService::Service]
            #
            attr_reader :organizer

            ##
            # @!attribute [r] propagated_result
            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            #
            attr_reader :propagated_result

            ##
            # @param object [Object] Can be any type.
            # @param organizer [ConvenientService::Service]
            # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            # @return [void]
            #
            def initialize(object:, organizer:, propagated_result: nil)
              @object = object
              @organizer = organizer
              @propagated_result = propagated_result
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerator]
            #
            def call
              return step_aware_enumerator_klass.new(object: object, organizer: organizer, propagated_result: propagated_result) if step_aware_enumerator_klass
              return fallback_step_aware_enumerator_klass.new(object: object, organizer: organizer, propagated_result: propagated_result) if fallback_step_aware_enumerator_klass

              raise ::ConvenientService.raise Exceptions::ObjectIsNotEnumerator.new(object: object)
            end

            ##
            # @return [Class, nil]
            #
            def step_aware_enumerator_klass
              Utils.memoize_including_falsy_values(self, :@step_aware_enumerator_klass) { RUBY_CLASS_TO_STEP_AWARE_CLASS_MAP[object.class] }
            end

            ##
            # @return [Class, nil]
            #
            def fallback_step_aware_enumerator_klass
              Utils.memoize_including_falsy_values(self, :@fallback_step_aware_enumerator_klass) { Entities::StepAwareEnumerables::Enumerator if object.respond_to?(:each) }
            end
          end
        end
      end
    end
  end
end
