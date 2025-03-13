# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Commands
          class CastStepAwareCollection < Support::Command
            include Support::DependencyContainer::Import

            ##
            # @!attribute [r] collection
            #   @return [Object] Can be any type.
            #
            attr_reader :collection

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
            # @param collection [Object] Can be any type.
            # @param organizer [ConvenientService::Service]
            # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            # @return [void]
            #
            def initialize(collection:, organizer:, propagated_result: nil)
              @collection = collection
              @organizer = organizer
              @propagated_result = propagated_result
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerator, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareLazyEnumerator]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::CollectionIsNotEnumerable]
            #
            def call
              case collection
              when Entities::StepAwareCollections::Value
                collection
              when Entities::StepAwareCollections::BooleanValue
                collection
              when Entities::StepAwareCollections::LazyEnumerator
                collection
              when Entities::StepAwareCollections::Enumerator
                collection
              when Entities::StepAwareCollections::Enumerable
                collection
              when ::Enumerator::Lazy
                Entities::StepAwareCollections::LazyEnumerator.new(lazy_enumerator: collection, organizer: organizer, propagated_result: propagated_result)
              when ::Enumerator
                Entities::StepAwareCollections::Enumerator.new(enumerator: collection, organizer: organizer, propagated_result: propagated_result)
              when ::Enumerable
                Entities::StepAwareCollections::Enumerable.new(enumerable: collection, organizer: organizer, propagated_result: propagated_result)
              else
                ::ConvenientService.raise Exceptions::CollectionIsNotEnumerable.new(collection: collection)
              end
            end
          end
        end
      end
    end
  end
end
