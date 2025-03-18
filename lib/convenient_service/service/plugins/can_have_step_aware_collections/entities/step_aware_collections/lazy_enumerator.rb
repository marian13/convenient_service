# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareCollections
        module Entities
          module StepAwareCollections
            class LazyEnumerator < Entities::StepAwareCollections::Enumerator
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
              # @!attribute [w] propagated_result
              #   @return [Enumerator::Lazy]
              #
              attr_writer :propagated_result

              ##
              # @api private
              #
              # @param lazy_enumerator [Enumerator::Lazy]
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [void]
              #
              def initialize(lazy_enumerator:, organizer:, propagated_result: nil)
                @lazy_enumerator = lazy_enumerator
                @organizer = organizer
                @propagated_result = propagated_result
              end

              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              def enumerable
                lazy_enumerator
              end

              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              def enumerator
                lazy_enumerator
              end

              ##
              # TODO: !!!
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
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
              # TODO: !!!
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
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
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def collect(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.collect(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def collect_concat(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.collect_concat(&step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def drop(n)
                process_without_block_return_lazy_enumerator(n) do |n|
                  lazy_enumerator.drop(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def drop_while(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.drop_while(&step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def eager
                process_as_enumerator do
                  lazy_enumerator.eager
                end
              end

              ##
              # TODO !!! Object.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def enum_for(method = :each, *args, &iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(method, *args, iteration_block) do |method, *args, step_aware_iteration_block|
                    lazy_enumerator.enum_for(method, *args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator do
                    lazy_enumerator.enum_for(method, *args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.filter(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter_map(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.filter_map(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def find_all(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.find_all(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def flat_map(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.flat_map(&step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def force
                process_as_enumerable do
                  lazy_enumerator.force
                end
              end

              ##
              # @param pattern [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def grep(pattern, &iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(pattern, iteration_block) do |pattern, step_aware_iteration_block|
                    lazy_enumerator.grep(pattern, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator(pattern) do |pattern|
                    lazy_enumerator.grep(pattern)
                  end
                end
              end

              ##
              # @param pattern [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def grep_v(pattern, &iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(pattern, iteration_block) do |pattern, step_aware_iteration_block|
                    lazy_enumerator.grep_v(pattern, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator(pattern) do |pattern|
                    lazy_enumerator.grep_v(pattern)
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def lazy
                process_without_block_return_lazy_enumerator do
                  lazy_enumerator
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def map(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.map(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def reject(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.reject(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def select(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.select(&step_aware_iteration_block)
                end
              end

              ##
              # @param pattern [Object, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_after(pattern, &iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                    lazy_enumerator.slice_after(&step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator(pattern) do |pattern|
                    lazy_enumerator.slice_after(pattern)
                  end
                end
              end

              ##
              # @param pattern [Object, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_before(pattern, &iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                    lazy_enumerator.slice_before(&step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator(pattern) do |pattern|
                    lazy_enumerator.slice_before(pattern)
                  end
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_when(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.slice_when(&step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def take(n)
                process_with_block_return_lazy_enumerator(n, nil) do |n|
                  lazy_enumerator.take(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def take_while(&iteration_block)
                process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                  lazy_enumerator.take_while(&step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_a
                process_as_enumerable(nil) do
                  lazy_enumerator.to_a
                end
              end

              ##
              # TODO !!! Object.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_enum(method = :each, *args, &iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(method, *args, iteration_block) do |method, *args, step_aware_iteration_block|
                    lazy_enumerator.to_enum(method, *args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator do
                    lazy_enumerator.to_enum(method, *args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def uniq(&iteration_block)
                if iteration_block
                  process_with_block_return_lazy_enumerator(iteration_block) do |step_aware_iteration_block|
                    lazy_enumerator.uniq(&step_aware_iteration_block)
                  end
                else
                  process_without_block_return_lazy_enumerator do
                    lazy_enumerator.uniq
                  end
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def zip(*args, &iteration_block)
                args = args.each { |collection| cast_step_aware_collection(collection) }.map(&:enumerable)

                if iteration_block
                  process_with_block_return_object(*args, iteration_block) do |*args, step_aware_iteration_block|
                    lazy_enumerator.zip(*args, &step_aware_iteration_block)
                  end
                else
                  process_with_block_return_lazy_enumerator(*args) do |*args|
                    lazy_enumerator.zip(*args)
                  end
                end
              end

              private

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
                      throw :propagated_result, {propagated_result: error_result}
                    end
                  end

                lazy_enumerator = yield(*args, step_aware_iteration_block)

                step_aware_lazy_enumerator_from(lazy_enumerator)
              end
            end
          end
        end
      end
    end
  end
end
