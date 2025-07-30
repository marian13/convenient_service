# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Commands
          class CastStepAwareEnumerable < Support::Command
            ##
            # @return [Hash{Class => Class}]
            #
            RUBY_CLASS_TO_STEP_AWARE_CLASS_MAP = {
              ::Array => Entities::StepAwareEnumerables::Array,
              ::Hash => Entities::StepAwareEnumerables::Hash,
              ::Set => Entities::StepAwareEnumerables::Set,
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
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::ObjectIsNotEnumerable]
            #
            def call
              step_aware_enumerable_klass&.new(**attributes) || ::ConvenientService.raise(Exceptions::ObjectIsNotEnumerable.new(object: object))
            end

            private

            ##
            # @return [Class]
            #
            def step_aware_enumerable_klass
              klass = RUBY_CLASS_TO_STEP_AWARE_CLASS_MAP[object.class]

              return klass if klass

              case object
              when ::Enumerator::Lazy then Entities::StepAwareEnumerables::LazyEnumerator
              when ::Enumerator::Chain then Entities::StepAwareEnumerables::ChainEnumerator
              when ::Enumerator then Entities::StepAwareEnumerables::Enumerator
              when ::Enumerable then Entities::StepAwareEnumerables::Enumerable
              end
            end

            ##
            # @return [Hash]
            #
            def attributes
              {object: object, organizer: organizer, propagated_result: propagated_result}
            end
          end
        end
      end
    end
  end
end
