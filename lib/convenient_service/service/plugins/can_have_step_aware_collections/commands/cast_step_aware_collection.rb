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
            # @!attribute [r] result
            #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            attr_reader :result

            ##
            # @param collection [Object] Can be any type.
            # @param organizer [ConvenientService::Service]
            # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
            # @return [void]
            #
            def initialize(collection:, organizer:, result: nil)
              @collection = collection
              @organizer = organizer
              @result = result
            end

            ##
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerator, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareLazyEnumerator]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::CollectionIsNotEnumerable]
            #
            def call
              case collection
              when Entities::StepAwareCollections::TerminalValue
                collection
              when Entities::StepAwareCollections::LazyEnumerator
                collection
              when Entities::StepAwareCollections::Enumerator
                collection
              when Entities::StepAwareCollections::Enumerable
                collection
              when ::Enumerator::Lazy
                Entities::StepAwareCollections::LazyEnumerator.new(lazy_enumerator: collection, organizer: organizer, result: result)
              when ::Enumerator
                Entities::StepAwareCollections::Enumerator.new(enumerator: collection, organizer: organizer, result: result)
              when ::Enumerable
                Entities::StepAwareCollections::Enumerable.new(enumerable: collection, organizer: organizer, result: result)
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
