# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Hash < Entities::StepAwareCollections::Enumerable
              ##
              # @api private
              #
              # @!attribute [r] hash
              #   @return [Hash]
              #
              attr_reader :hash

              ##
              # @api private
              #
              # @param hash [Hash]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(hash:, organizer:, propagated_result: nil)
                @hash = hash
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @return [Symbol]
              #
              def default_evaluate_by
                :to_h
              end

              ##
              # @api private
              #
              # @return [Hash]
              #
              def enumerable
                hash
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  process_as_hash(iteration_block) do |step_aware_iteration_block|
                    hash.each(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(nil) do
                    hash.each
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter(&iteration_block)
                if iteration_block
                  process_as_hash(iteration_block) do |step_aware_iteration_block|
                    hash.filter(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    hash.filter
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def reject(&iteration_block)
                if iteration_block
                  process_as_hash(iteration_block) do |step_aware_iteration_block|
                    hash.reject(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(nil) do
                    hash.reject
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def reverse_each(&iteration_block)
                if iteration_block
                  process_as_hash(iteration_block) do |step_aware_iteration_block|
                    hash.reverse_each(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(nil) do
                    hash.reverse_each
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def select(&iteration_block)
                if iteration_block
                  process_as_hash(iteration_block) do |step_aware_iteration_block|
                    hash.select(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    hash.select
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
