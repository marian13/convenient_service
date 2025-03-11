# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Concern
          include Support::Concern

          instance_methods do
            ##
            # @api public
            #
            # @param value [Enumerable]
            # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareEnumerator, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareLazyEnumerator]
            # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Exceptions::CollectionIsNotEnumerable]
            #
            def collection(value)
              Commands::CastStepAwareCollection.call(collection: value, organizer: self)
            end
          end
        end
      end
    end
  end
end
