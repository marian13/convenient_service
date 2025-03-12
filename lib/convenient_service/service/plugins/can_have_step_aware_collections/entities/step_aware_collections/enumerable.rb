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
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(enumerable:, organizer:, result: nil)
                @enumerable = enumerable
                @organizer = organizer
                @result = result
              end

              ##
              # @return [Boolean]
              #
              def has_error_result?
                return false unless result

                result.error?
              end

              ##
              # @return [Boolean]
              #
              def has_terminal_chaining?
                Utils.to_bool(terminal_chaining)
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def all?(*args, &iteration_block)
                if has_error_result?
                  return Entities::StepAwareCollections::TerminalValue.new(
                    organizer: organizer,
                    result: result
                  )
                end

                step_aware_iteration_block =
                  if iteration_block
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)
                      next true if value.success?
                      next false if value.failure?

                      return Entities::StepAwareCollections::TerminalValue.new(
                        organizer: organizer,
                        result: value.result
                      )
                    end
                  end

                Entities::StepAwareCollections::TerminalValue.new(
                  organizer: organizer,
                  result: enumerable.all?(*args, &step_aware_iteration_block) ? success : failure
                )
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def any?(*args, &iteration_block)
                if has_error_result?
                  return Entities::StepAwareCollections::TerminalValue.new(
                    organizer: organizer,
                    result: result
                  )
                end

                step_aware_iteration_block =
                  if iteration_block
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)
                      next true if value.success?
                      next false if value.failure?

                      return Entities::StepAwareCollections::TerminalValue.new(
                        organizer: organizer,
                        result: value.result
                      )
                    end
                  end

                Entities::StepAwareCollections::TerminalValue.new(
                  organizer: organizer,
                  result: enumerable.any?(*args, &step_aware_iteration_block) ? success : failure
                )
              end

              ##
              # @param enums [Array<Enumerable>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def chain(*enums)
                step_aware_collections = enums.map { |enum| cast_step_aware_collection(enum) }

                chain_enumerator = enumerable.chain(*step_aware_collections.map(&:enumerable))

                Entities::StepAwareCollections::ChainEnumerator.new(
                  chain_enumerator: chain_enumerator,
                  organizer: organizer
                )
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::ChunkEnumerator]
              #
              def chunk(&iteration_block)
                if has_error_result?
                  return Entities::StepAwareCollections::ChunkEnumerator.new(
                    enumerable: enumerable,
                    iteration_block: iteration_block,
                    organizer: organizer,
                    result: result
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
                if has_error_result?
                  return Entities::StepAwareCollections::ChunkWhileEnumerator.new(
                    enumerable: enumerable,
                    iteration_block: iteration_block,
                    organizer: organizer,
                    result: result
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
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def collect(&iteration_block)
                if iteration_block
                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerable.new(
                      enumerable: enumerable,
                      organizer: organizer,
                      result: result
                    )
                  end

                  step_aware_iteration_block =
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)

                      if value.success?
                        next true if value.outputs.none?

                        next value.outputs.one? ? value.output_values.values.first : value.output_values
                      end

                      if value.failure?
                        next false if value.outputs.none?

                        next value.outputs.one? ? nil : {}
                      end

                      return Entities::StepAwareCollections::Enumerable.new(
                        enumerable: enumerable,
                        organizer: organizer,
                        result: value.result
                      )
                    end

                  enumerable = self.enumerable.collect(&step_aware_iteration_block)

                  Entities::StepAwareCollections::Enumerable.new(
                    enumerable: enumerable,
                    organizer: organizer,
                    result: success(values: enumerable)
                  )
                else
                  enumerator = self.enumerable.collect

                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerator.new(
                      enumerator: enumerator,
                      organizer: organizer,
                      result: result
                    )
                  end

                  Entities::StepAwareCollections::Enumerator.new(
                    enumerator: enumerator,
                    organizer: organizer,
                    result: success(values: enumerator)
                  )
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def collect_concat(&iteration_block)
                if iteration_block
                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerable.new(
                      enumerable: enumerable,
                      organizer: organizer,
                      result: result
                    )
                  end

                  step_aware_iteration_block =
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)

                      if value.success?
                        next true if value.outputs.none?

                        next value.outputs.one? ? value.output_values.values.first : value.output_values
                      end

                      if value.failure?
                        next false if value.outputs.none?

                        next value.outputs.one? ? nil : {}
                      end

                      return Entities::StepAwareCollections::Enumerable.new(
                        enumerable: enumerable,
                        organizer: organizer,
                        result: value.result
                      )
                    end

                  enumerable = self.enumerable.collect_concat(&step_aware_iteration_block)

                  Entities::StepAwareCollections::Enumerable.new(
                    enumerable: enumerable,
                    organizer: organizer,
                    result: success(values: enumerable)
                  )
                else
                  enumerator = self.enumerable.collect_concat

                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerator.new(
                      enumerator: enumerator,
                      organizer: organizer,
                      result: result
                    )
                  end

                  Entities::StepAwareCollections::Enumerator.new(
                    enumerator: enumerator,
                    organizer: organizer,
                    result: success(values: enumerator)
                  )
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def count(*args, &iteration_block)
                if has_error_result?
                  return Entities::StepAwareCollections::TerminalValue.new(
                    organizer: organizer,
                    result: result
                  )
                end

                step_aware_iteration_block =
                  if iteration_block
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)
                      next true if value.success?
                      next false if value.failure?

                      return Entities::StepAwareCollections::TerminalValue.new(
                        organizer: organizer,
                        result: value.result
                      )
                    end
                  end

                Entities::StepAwareCollections::TerminalValue.new(
                  organizer: organizer,
                  result: success(value: enumerable.count(*args, &step_aware_iteration_block))
                )
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def cycle(*args, &iteration_block)
                if iteration_block
                  if has_error_result?
                    return Entities::StepAwareCollections::TerminalValue.new(
                      organizer: organizer,
                      result: result
                    )
                  end

                  step_aware_iteration_block =
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)
                      next true if value.success?
                      next false if value.failure?

                      return Entities::StepAwareCollections::TerminalValue.new(
                        organizer: organizer,
                        result: value.result
                      )
                    end

                  Entities::StepAwareCollections::TerminalValue.new(
                    organizer: organizer,
                    result: success(value: enumerable.cycle(*args, &step_aware_iteration_block))
                  )
                else
                  enumerator = enumerable.cycle(*args)

                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerator.new(
                      enumerator: enumerator,
                      organizer: organizer,
                      result: result
                    )
                  end

                  Entities::StepAwareCollections::Enumerator.new(
                    enumerator: enumerator,
                    organizer: organizer,
                    result: success(values: enumerator)
                  )
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def detect(*args, &iteration_block)
                if iteration_block
                  if has_error_result?
                    return Entities::StepAwareCollections::TerminalValue.new(
                      organizer: organizer,
                      result: result
                    )
                  end

                  step_aware_iteration_block =
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)
                      next true if value.success?
                      next false if value.failure?

                      return Entities::StepAwareCollections::TerminalValue.new(
                        organizer: organizer,
                        result: value.result
                      )
                    end

                  value = enumerable.detect(*args, &step_aware_iteration_block)

                  Entities::StepAwareCollections::TerminalValue.new(
                    organizer: organizer,
                    result: value ? success(value: value) : failure
                  )
                else
                  enumerator = enumerable.detect(*args)

                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerator.new(
                      enumerator: enumerator,
                      organizer: organizer,
                      result: result
                    )
                  end

                  Entities::StepAwareCollections::Enumerator.new(
                    enumerator: enumerator,
                    organizer: organizer,
                    result: success(values: enumerator)
                  )
                end
              end

              ##
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::TerminalValue]
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
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
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
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::TerminalValue, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
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
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def each(&iteration_block)
                if iteration_block
                  step_aware_iteration_block =
                    proc do |*args|
                      value = yield(*args)

                      next value unless Plugins::CanHaveSteps.step?(value)
                      next value if value.not_error?

                      return Entities::StepAwareCollections::Enumerable.new(
                        enumerable: enumerable,
                        organizer: organizer,
                        result: value.result
                      )
                    end

                  enumerable = self.enumerable.each(&step_aware_iteration_block)

                  Entities::StepAwareCollections::Enumerable.new(
                    enumerable: enumerable,
                    organizer: organizer,
                    result: success(values: enumerable)
                  )
                else
                  enumerator = self.enumerable.each

                  Entities::StepAwareCollections::Enumerator.new(
                    enumerator: enumerator,
                    organizer: organizer,
                    result: success(values: enumerator)
                  )
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::TerminalValue]
              #
              def first(n = nil)
                if n
                  if has_error_result?
                    return Entities::StepAwareCollections::Enumerable.new(
                      enumerable: enumerable,
                      organizer: organizer,
                      result: result
                    )
                  end

                  enumerable = self.enumerable.first(n)

                  Entities::StepAwareCollections::Enumerable.new(
                    enumerable: enumerable,
                    organizer: organizer,
                    result: success(values: enumerable)
                  )
                else
                  if has_error_result?
                    return Entities::StepAwareCollections::TerminalValue.new(
                      organizer: organizer,
                      result: result
                    )
                  end

                  value = self.enumerable.first

                  Entities::StepAwareCollections::TerminalValue.new(
                    organizer: organizer,
                    result: value ? success(value: value) : failure
                  )
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::LazyEnumerator]
              #
              def lazy
                lazy_enumerator = enumerable.lazy

                Entities::StepAwareEnumerator.new(
                  lazy_enumerator: lazy_enumerator,
                  organizer: organizer,
                  result: success(values: lazy_enumerator)
                )
              end

              ##
              # @param data_key [Symbol, nil]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: nil)
                return organizer.success(data_key || :values => enumerable) unless @result
                return @result if @result.not_success?
                return @result unless data_key

                @result.copy(
                  overrides: {
                    kwargs: {
                      data: {
                        data_key => @result.unsafe_data[:values]
                      }
                    }
                  }
                )
              end

              private

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::TerminalValue]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def process_with_block_return_value(args, iteration_block, &iterator_block)
                return step_aware_value_from(result) if has_error_result?

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_value_from(error_result)
                  end

                value = yield(args, step_aware_iteration_block)

                step_aware_value_from(success(value: value))
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::TerminalValue]
              #
              # @internal
              #   NOTE: `step_aware_iteration_block` is inlined in order to have a way to return from enclosing method.
              #
              def process_with_block_return_enumerable(args, iteration_block, &iterator_block)
                return step_aware_enumerable_from(self.enumerable, result) if has_error_result?

                step_aware_iteration_block =
                  step_aware_iteration_block_from(iteration_block) do |error_result|
                    return step_aware_enumerable_from(self.enumerable, error_result)
                  end

                enumerable = iterator_block.call(args, step_aware_iteration_block)

                step_aware_enumerable_from(enumerable, success(values: enumerable))
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
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_value(args, iterator_block)
                value = iterator_block.call(args, nil)

                step_aware_value_from(enumerator, error_result || success(value: value))
              end

              ##
              # @param args [Array<Object>]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def process_without_block_return_enumerator(args, &iterator_block)
                enumerator = iterator_block.call(args)

                step_aware_enumerator_from(enumerator, error_result || success(values: enumerator))
              end

              ##
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::TerminalValue]
              #
              def step_aware_value_from(result)
                Entities::StepAwareCollections::TerminalValue.new(organizer: organizer, result: result)
              end

              ##
              # @param enumerable [Enumerable]
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def step_aware_enumerable_from(enumerable, result)
                Entities::StepAwareCollections::Enumerable.new(enumerable: enumerable, organizer: organizer, result: result)
              end

              ##
              # @param enumerator [Enumerator]
              # @param result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerator]
              #
              def step_aware_enumerator_from(enumerator, result)
                Entities::StepAwareCollections::Enumerator.new(enumerator: enumerator, organizer: organizer, result: result)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              #
              def error_result
                result if has_error_result?
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

              ##
              # @param collection [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def cast_step_aware_collection(collection)
                Commands::CastStepAwareCollection.call(collection: collection, organizer: organizer, result: result)
              end
            end
          end
        end
      end
    end
  end
end
