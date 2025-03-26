# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class Base
              include Support::AbstractMethod

              ##
              # @api private
              #
              # @!attribute [r] organizer
              #   @return [ConvenientService::Service]
              #
              attr_reader :organizer

              ##
              # @api private
              #
              # @!attribute [rw] propagated_result
              #   @return[ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              #
              attr_accessor :propagated_result

              ##
              # @api private
              #
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              abstract_method :result

              private

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              # @internal
              #   NOTE: `catch` is used to support lazy enumerators.
              #
              def process_as_boolean(*args, iteration_block, &iterator_block)
                return step_aware_object_from(false) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_object_from(false, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {boolean: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_boolean_from(false, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_boolean_from(response[:boolean])
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_object(*args, iteration_block, &iterator_block)
                return step_aware_object_from(nil) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_object_from(nil, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {object: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_object_from(nil, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_object_from(response[:object])
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              alias_method :process_as_string, :process_as_object

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              alias_method :process_as_integer, :process_as_object

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_object_or_nil(*args, iteration_block, &iterator_block)
                return step_aware_object_or_nil_from(nil) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_object_or_nil_from(nil, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {object_or_nil: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_object_or_nil_from(nil, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_object_or_nil_from(response[:object_or_nil])
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_enumerable(*args, iteration_block, &iterator_block)
                return step_aware_enumerable_from(enumerable) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_enumerable_from(enumerable, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {values: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_enumerable_from(enumerable, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_enumerable_from(response[:values])
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_enumerable_or_empty(*args, iteration_block, &iterator_block)
                return step_aware_enumerable_or_empty_from(enumerable) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_enumerable_or_empty_from(enumerable, error_result)
                  end

                enumerable = yield(*args, step_aware_iteration_block)

                step_aware_enumerable_or_empty_from(enumerable)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_array(*args, iteration_block, &iterator_block)
                return step_aware_array_from(array) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_array_from(array, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {values: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_array_from(array, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_array_from(response[:values])
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_hash(*args, iteration_block, &iterator_block)
                return step_aware_hash_from(hash) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_hash_from(hash, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {values: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_hash_from(hash, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_hash_from(response[:values])
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_set(*args, iteration_block, &iterator_block)
                return step_aware_set_from(enumerable.to_set) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_set_from(enumerable.to_set, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {values: yield(*args, step_aware_iteration_block)}
                  end

                # TODO: !!!
                return step_aware_set_from(enumerable, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_set_from(response[:values])
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_as_range(*args, iteration_block, &iterator_block)
                # TODO: !!!
                return step_aware_range_from(range) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_range_from(range, error_result)
                    end
                  end

                response =
                  catch :propagated_result do
                    {values: yield(*args, step_aware_iteration_block)}
                  end

                return step_aware_range_from(range, response[:propagated_result]) if response.has_key?(:propagated_result)

                step_aware_range_from(response[:values])
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_as_enumerator(*args, iteration_block, &iterator_block)
                return step_aware_enumerator_from(enumerable.to_enum) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_enumerator_from(enumerable, error_result)
                    end
                  end

                enumerable = yield(*args, step_aware_iteration_block)

                step_aware_enumerator_from(enumerable)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_as_enumerator_generator(*args, iteration_block, &iterator_block)
                return step_aware_enumerator_from(enumerable.lazy) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      throw :propagated_result, {propagated_result: error_result}
                    end
                  end

                lazy_enumerator = yield(*args, step_aware_iteration_block)

                step_aware_enumerator_from(lazy_enumerator)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_as_lazy_enumerator(*args, iteration_block, &iterator_block)
                return step_aware_lazy_enumerator_from(enumerable.lazy) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      throw :propagated_result, {propagated_result: error_result}
                    end
                  end

                lazy_enumerator = yield(*args, step_aware_iteration_block)

                step_aware_lazy_enumerator_from(lazy_enumerator)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_as_chain_enumerator(*args, iteration_block, &iterator_block)
                return step_aware_chain_enumerator_from(enumerable.chain) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      throw :propagated_result, {propagated_result: error_result}
                    end
                  end

                chain_enumerator = yield(*args, step_aware_iteration_block)

                step_aware_chain_enumerator_from(chain_enumerator)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_as_arithmetic_sequence_enumerator(*args, iteration_block, &iterator_block)
                return step_aware_arithmetic_sequence_enumerator_from(enumerable) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_arithmetic_sequence_enumerator_from(enumerable, error_result)
                    end
                  end

                arithmetic_sequence_enumerator = yield(*args, step_aware_iteration_block)

                step_aware_arithmetic_sequence_enumerator_from(arithmetic_sequence_enumerator)
              end

              ##
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
                    next value.outputs.none? ? false : nil
                  end

                  yield(value.result)

                  ::ConvenientService.raise Support::NeverReachHere.new(extra_message: "Step aware iteration block issue.")
                end
              end

              ##
              # @param boolean [Boolean]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def step_aware_boolean_from(boolean, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Boolean.new(object: boolean, organizer: organizer, propagated_result: propagated_result || (failure if boolean != true))
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def step_aware_object_from(object, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Object.new(object: object, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def step_aware_object_or_nil_from(object, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Object.new(object: object, organizer: organizer, propagated_result: propagated_result || (failure unless object))
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
              # @param array [Array]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_array_from(array, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Array.new(array: array, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param hash [Hash]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_hash_from(hash, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Hash.new(hash: hash, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param set [Set]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_set_from(set, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Set.new(set: set, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param range [Range]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_range_from(range, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::Range.new(range: range, organizer: organizer, propagated_result: propagated_result)
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
              # @param chain_enumerator [Enumerator::Chain]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::ChainEnumerator]
              #
              def step_aware_chain_enumerator_from(chain_enumerator, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::ChainEnumerator.new(chain_enumerator: chain_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param arithmetic_sequence_enumerator [Enumerator::ArithmeticSequence]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::ArithmeticSequence::Enumerator]
              #
              def step_aware_arithmetic_sequence_enumerator_from(arithmetic_sequence_enumerator, propagated_result = self.propagated_result)
                Entities::StepAwareCollections::ArithmeticSequenceEnumerator.new(arithmetic_sequence_enumerator: arithmetic_sequence_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param collection [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def cast_step_aware_collection(collection)
                Commands::CastStepAwareCollection.call(collection: collection, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def success(...)
                organizer.success(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def failure(...)
                organizer.failure(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def error(...)
                organizer.error(...)
              end
            end
          end
        end
      end
    end
  end
end
