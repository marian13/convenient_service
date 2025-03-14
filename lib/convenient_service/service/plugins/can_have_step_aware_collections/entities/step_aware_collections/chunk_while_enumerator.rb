# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class ChunkWhileEnumerator < Entities::StepAwareCollections::Enumerator
              ##
              # @api private
              #
              # @!attribute [r] enumerable
              #   @return [Enumerable]
              #
              attr_reader :enumerable

              ##
              # @api private
              #
              # @!attribute [r] iteration_block
              #   @return [Proc]
              #
              attr_reader :iteration_block

              ##
              # @api private
              #
              # @!attribute [w] result
              #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              attr_writer :result

              ##
              # @api private
              #
              # @param enumerable [Enumerable]
              # @param iteration_block [Proc]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(enumerable:, iteration_block:, organizer:, propagated_result: nil)
                @enumerable = enumerable
                @iteration_block = iteration_block
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: nil)
                return propagated_result if propagated_result

                enumerable = enumerator.to_a

                return @result if @result

                success(data_key || :values => enumerable)
              end

              ##
              # @return [Enumerator]
              #
              def enumerator
                ::Enumerator.new do |yielder|
                  step_aware_iteration_block =
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      @result = error_result

                      raise StopIteration
                    end

                  chunk_enumerator = enumerable.chunk_while(&step_aware_iteration_block)

                  loop { yielder << chunk_enumerator.next }
                end
              end
            end
          end
        end
      end
    end
  end
end
