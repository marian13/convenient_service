# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class LazyEnumerator < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] lazy_enumerator
              #   @return [Enumerator::Lazy]
              #
              attr_reader :lazy_enumerator

              ##
              # @api private
              #
              # @param lazy_enumerator [Enumerator::Lazy]
              # @param organizer [ConvenientService::Service]
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(lazy_enumerator:, organizer:, result: nil)
                @lazy_enumerator = lazy_enumerator
                @organizer = organizer
                @result = result
              end

              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              def enumerable
                lazy_enumerator
              end
            end
          end
        end
      end
    end
  end
end
