# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveServiceAwareEnumerables
        module Commands
          class CastServiceAwareEnumerable < Support::Command
            ##
            # @return [Hash{Class => Class}]
            #
            RUBY_CLASS_TO_SERVICE_AWARE_CLASS_MAP = {
              ::Array => Entities::ServiceAwareEnumerables::Array,
              ::Hash => Entities::ServiceAwareEnumerables::Hash,
              ::Set => Entities::ServiceAwareEnumerables::Set,
              ::Enumerator => Entities::ServiceAwareEnumerables::Enumerator,
              ::Enumerator::Lazy => Entities::ServiceAwareEnumerables::LazyEnumerator,
              ::Enumerator::Chain => Entities::ServiceAwareEnumerables::ChainEnumerator,
              ::Enumerator::ArithmeticSequence => Entities::ServiceAwareEnumerables::ArithmeticSequenceEnumerator
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
            # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
            # @raise [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Exceptions::ObjectIsNotEnumerable]
            #
            def call
              service_aware_enumerable_klass&.new(**attributes) || ::ConvenientService.raise(Exceptions::ObjectIsNotEnumerable.new(object: object))
            end

            private

            ##
            # @return [Class]
            #
            def service_aware_enumerable_klass
              klass = RUBY_CLASS_TO_SERVICE_AWARE_CLASS_MAP[object.class]

              return klass if klass

              case object
              when ::Enumerator::Lazy then Entities::ServiceAwareEnumerables::LazyEnumerator
              when ::Enumerator::Chain then Entities::ServiceAwareEnumerables::ChainEnumerator
              when ::Enumerator then Entities::ServiceAwareEnumerables::Enumerator
              when ::Enumerable then Entities::ServiceAwareEnumerables::Enumerable
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
