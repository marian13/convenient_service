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
              def process_with_block_return_object(*args, iteration_block, &iterator_block)
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
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_object(*args, &iterator_block)
                process_with_block_return_object(*args, nil, &iterator_block)
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Object]
              #
              def process_with_block_return_object_or_nil(*args, iteration_block, &iterator_block)
                return step_aware_object_or_nil_from(nil) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_object_or_nil_from(nil, error_result)
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
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_object_or_nil(*args, &iterator_block)
                return step_aware_object_or_nil_from(nil) if propagated_result

                response =
                  catch :propagated_result do
                    {object_or_nil: yield(*args)}
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

                enumerable = yield(*args, step_aware_iteration_block)

                step_aware_enumerable_from(enumerable)
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
              def process_with_block_return_lazy_enumerator(*args, iteration_block, &iterator_block)
                return step_aware_lazy_enumerator_from(enumerable.lazy) if propagated_result

                step_aware_iteration_block =
                  if iteration_block
                    step_aware_iteration_block_from(iteration_block) do |error_result|
                      return step_aware_enumerable_or_empty_from(enumerable, error_result)
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
              def process_with_block_return_lazy_enumerator_or_empty(*args, iteration_block, &iterator_block)
                return step_aware_lazy_enumerator_from(enumerable.lazy) if propagated_result

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_enumerable_or_empty_from(enumerable, error_result)
                  end

                lazy_enumerator = yield(*args, step_aware_iteration_block)

                step_aware_lazy_enumerator_from(lazy_enumerator)
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_lazy_enumerator(*args, &iterator_block)
                return step_aware_lazy_enumerator_from(enumerable.lazy) if propagated_result

                lazy_enumerator = yield(*args)

                step_aware_lazy_enumerator_from(lazy_enumerator)
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
