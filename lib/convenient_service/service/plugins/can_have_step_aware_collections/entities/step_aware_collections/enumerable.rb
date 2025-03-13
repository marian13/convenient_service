# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Enumerable < Entities::StepAwareCollections::Base
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
              # @param enumerable [Enumerable]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(enumerable:, organizer:, propagated_result: nil)
                @enumerable = enumerable
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @param data_key [Symbol, nil]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: nil)
                return propagated_result if propagated_result

                success(data_key || :values => enumerable)
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def all?(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_boolean_value(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.all?(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_boolean_value(args) do |args|
                    enumerable.all?(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def any?(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_boolean_value(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.any?(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_boolean_value(args) do |args|
                    enumerable.any?(*args)
                  end
                end
              end

              ##
              # @param enums [Array<Enumerable>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def chain(*enums)
                return step_aware_chain_enumerator_from(enumerable.chain) if propagated_result

                step_aware_collections = enums.map { |enum| cast_step_aware_collection(enum) }

                chain_enumerator = enumerable.chain(*step_aware_collections.map(&:enumerable))

                step_aware_chain_enumerator_from(chain_enumerator)
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::ChunkEnumerator]
              #
              def chunk(&iteration_block)
                if propagated_result
                  return Entities::StepAwareCollections::ChunkEnumerator.new(
                    enumerable: enumerable,
                    iteration_block: iteration_block,
                    organizer: organizer,
                    propagated_result: propagated_result
                  )
                end

                Entities::StepAwareCollections::ChunkEnumerator.new(
                  enumerable: enumerable,
                  iteration_block: iteration_block,
                  organizer: organizer
                )
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::ChunkWhileEnumerator]
              #
              def chunk_while(&iteration_block)
                if propagated_result
                  return Entities::StepAwareCollections::ChunkWhileEnumerator.new(
                    enumerable: enumerable,
                    iteration_block: iteration_block,
                    organizer: organizer,
                    propagated_result: propagated_result
                  )
                end

                Entities::StepAwareCollections::ChunkWhileEnumerator.new(
                  enumerable: enumerable,
                  iteration_block: iteration_block,
                  organizer: organizer
                )
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def collect(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.collect(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.collect(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def collect_concat(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.collect_concat(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.collect_concat(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def count(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_value(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.count(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_value(args) do |args|
                    enumerable.count(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def cycle(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_value(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.cycle(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.cycle(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def detect(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_value_or_nil(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.detect(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.detect(*args)
                  end
                end
              end

              ##
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def drop(*args)
                process_without_block_return_enumerator(args) do |args|
                  enumerable.drop(*args)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def drop_while(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.drop_while(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.drop_while(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each_cons(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.each_cons(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.each_cons(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each_entry(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.each_entry(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.each_entry(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each_slice(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.each_slice(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.each_slice(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each_with_index(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.each_with_index(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.each_with_index(*args)
                  end
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def each_with_object(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_value(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.each_with_object(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.each_with_object(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerable(args, iteration_block) do |args, step_aware_iteration_block|
                    enumerable.each(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_enumerator(args) do |args|
                    enumerable.each(*args)
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def first(*args)
                if args.any?
                  process_without_block_return_enumerable(args) do |args|
                    enumerable.first(*args)
                  end
                else
                  process_without_block_return_value_or_nil do
                    enumerable.first
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::LazyEnumerator]
              #
              def lazy
                step_aware_lazy_enumerator_from(enumerable.lazy)
              end

              private

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def process_with_block_return_boolean_value(args, iteration_block, &iterator_block)
                return step_aware_value_from(false) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_value_from(false, error_result)
                  end

                boolean_value = iterator_block.call(args, step_aware_iteration_block)

                step_aware_boolean_value_from(boolean_value)
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_boolean_value(args = [], &iterator_block)
                return step_aware_value_from(false) if propagated_result

                boolean_value = iterator_block.call(args, nil)

                step_aware_boolean_value_from(boolean_value)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def process_with_block_return_value(args, iteration_block, &iterator_block)
                return step_aware_value_from(nil) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_value_from(nil, error_result)
                  end

                value = iterator_block.call(args, step_aware_iteration_block)

                step_aware_value_from(value)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def process_with_block_return_value_or_nil(args, iteration_block, &iterator_block)
                return step_aware_value_or_nil_from(nil) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_value_or_nil_from(nil, error_result)
                  end

                value = iterator_block.call(args, step_aware_iteration_block)

                step_aware_value_or_nil_from(value)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def process_with_block_return_enumerable(args, iteration_block, &iterator_block)
                return step_aware_enumerable_from(self.enumerable) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_enumerable_from(self.enumerable, error_result)
                  end

                enumerable = iterator_block.call(args, step_aware_iteration_block)

                step_aware_enumerable_from(enumerable)
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_value(args = [], &iterator_block)
                return step_aware_value_from(nil) if propagated_result

                value = iterator_block.call(args, nil)

                step_aware_value_from(value)
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_value_or_nil(args = [], &iterator_block)
                return step_aware_value_or_nil_from(nil) if propagated_result

                value_or_nil = iterator_block.call(args, nil)

                step_aware_value_or_nil_from(value_or_nil)
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_enumerable(args = [], &iterator_block)
                return step_aware_enumerable_from(self.enumerable) if propagated_result

                enumerable = iterator_block.call(args)

                step_aware_enumerable_from(enumerable)
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_enumerator(args = [], &iterator_block)
                return step_aware_enumerator_from(enumerable.to_enum) if propagated_result

                enumerator = iterator_block.call(args)

                step_aware_enumerator_from(enumerator)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @param error_block [Proc]
              # @return [Proc]
              #
              def step_aware_iteration_block_from(iteration_block, &error_block)
                proc do |*args|
                  value = iteration_block.call(*args)

                  next value unless Plugins::CanHaveSteps.step?(value)

                  if value.success?
                    next true if value.outputs.none?

                    next value.outputs.one? ? value.output_values.values.first : value.output_values
                  end

                  if value.failure?
                    next false if value.outputs.none?

                    next value.outputs.one? ? nil : {}
                  end

                  error_block.call(value.result)
                end
              end

              ##
              # @param boolean_value [Boolean]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def step_aware_boolean_value_from(boolean_value, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::BooleanValue.new(value: boolean_value, organizer: organizer, propagated_result: propagated_result || (failure unless boolean_value))
              end

              ##
              # @param value [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def step_aware_value_from(value, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Value.new(value: value, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param value [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Value]
              #
              def step_aware_value_or_nil_from(value, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Value.new(value: value, organizer: organizer, propagated_result: propagated_result || (failure unless value))
              end

              ##
              # @param enumerable [Enumerable]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_enumerable_from(enumerable, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Enumerable.new(enumerable: enumerable, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param enumerable [Enumerable]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_enumerable_or_empty_from(enumerable, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Enumerable.new(enumerable: enumerable, organizer: organizer, propagated_result: propagated_result || (failure if enumerable.size == 0))
              end

              ##
              # @param enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def step_aware_enumerator_from(enumerator, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Enumerator.new(enumerator: enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param lazy_enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def step_aware_lazy_enumerator_from(lazy_enumerator, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::LazyEnumerator.new(lazy_enumerator: lazy_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param lazy_enumerator [Enumerator::Chain]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def step_aware_chain_enumerator_from(chain_enumerator, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::ChainEnumerator.new(chain_enumerator: chain_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param collection [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def cast_step_aware_collection(collection)
                Commands::CastStepAwareCollection.call(collection: collection, organizer: organizer, propagated_result: propagated_result)
              end
            end
          end
        end
      end
    end
  end
end
