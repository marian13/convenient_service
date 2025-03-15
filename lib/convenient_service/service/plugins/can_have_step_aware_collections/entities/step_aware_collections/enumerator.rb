# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Enumerator < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] enumerator
              #   @return [Enumerator]
              #
              attr_reader :enumerator

              ##
              # @api private
              #
              # @param enumerator [Enumerator]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(enumerator:, organizer:, propagated_result: nil)
                @enumerator = enumerator
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @param data_key [Symbol, nil]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              # @internal
              #   NOTE: `catch` is used to support lazy enumerators.
              #
              def result(data_key: nil)
                return propagated_result if propagated_result

                response =
                  catch :propagated_result do
                    {values: enumerator.to_a}
                  end

                return response[:propagated_result] if response.has_key?(:propagated_result)

                success(data_key || :values => response[:values])
              end

              ##
              # @api private
              #
              # @return [Enumerator]
              #
              def enumerable
                enumerator
              end
            end
          end
        end
      end
    end
  end
end
