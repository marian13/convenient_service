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
              # @overload all?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload all?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def all?(*args, &iteration_block)
                process_as_boolean(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.all?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload any?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload any?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def any?(*args, &iteration_block)
                process_as_boolean(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.any?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param enums [Array<Enumerable>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def chain(*enums)
                return step_aware_chain_enumerator_from(enumerable.chain) if propagated_result

                step_aware_collections = enums.map { |enum| cast_step_aware_collection(enum) }

                chain_enumerator = enumerable.chain(*step_aware_collections.map(&:enumerable))

                step_aware_chain_enumerator_from(chain_enumerator)
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
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.collect(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.collect
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def collect_concat(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.collect_concat(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.collect_concat
                  end
                end
              end

              ##
              # @overload count
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload count(item)
              #   @param item [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload count(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def count(*args, &iteration_block)
                process_with_block_return_object(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.count(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def cycle(n = nil, &iteration_block)
                if iteration_block
                  process_with_block_return_object(n, iteration_block) do |n, step_aware_iteration_block|
                    enumerable.cycle(n, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(n, iteration_block) do |n|
                    enumerable.cycle(n)
                  end
                end
              end

              ##
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def detect(ifnone = nil, &iteration_block)
                if iteration_block
                  process_with_block_return_object_or_nil(ifnone, iteration_block) do |ifnone, step_aware_iteration_block|
                    enumerable.detect(ifnone, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(ifnone) do |ifnone|
                    enumerable.detect(ifnone)
                  end
                end
              end

              ##
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def drop(n)
                process_as_enumerable(n) do |n|
                  enumerable.drop(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def drop_while(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.drop_while(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.drop_while
                  end
                end
              end

              ##
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def each_cons(n, &iteration_block)
                if iteration_block
                  process_as_enumerable(n, iteration_block) do |n, step_aware_iteration_block|
                    enumerable.each_cons(n, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(n) do |n|
                    enumerable.each_cons(n)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def each_entry(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.each_entry(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.each_entry
                  end
                end
              end

              ##
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def each_slice(n, &iteration_block)
                if iteration_block
                  process_as_enumerable(n, iteration_block) do |n, step_aware_iteration_block|
                    enumerable.each_slice(n, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(n) do |n|
                    enumerable.each_slice(n)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.each_with_index(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.each_with_index
                  end
                end
              end

              ##
              # @param obj [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def each_with_object(obj, &iteration_block)
                if iteration_block
                  process_with_block_return_object(obj, iteration_block) do |obj, step_aware_iteration_block|
                    enumerable.each_with_object(obj, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(obj) do |obj|
                    enumerable.each_with_object(obj)
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def entries
                process_as_enumerable do
                  enumerable.entries
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.filter(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.filter
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def filter_map(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.filter_map(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.filter_map
                  end
                end
              end

              ##
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def find(ifnone = nil, &iteration_block)
                if iteration_block
                  process_with_block_return_object_or_nil(ifnone, iteration_block) do |ifnone, step_aware_iteration_block|
                    enumerable.find(ifnone, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(ifnone) do |ifnone|
                    enumerable.find(ifnone)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def find_all(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.find_all(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.find_all
                  end
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def find_index(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_object_or_nil(iteration_block) do |step_aware_iteration_block|
                    enumerable.find_index(&step_aware_iteration_block)
                  end
                elsif args.any?
                  process_with_block_return_object_or_nil(args.first) do |value|
                    enumerable.find_index(value)
                  end
                else
                  process_as_enumerator do
                    enumerable.find_index
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def first(n = nil)
                if n
                  process_as_enumerable(n) do |n|
                    enumerable.first(n)
                  end
                else
                  process_without_block_return_object_or_nil do
                    enumerable.first
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def flat_map(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.flat_map(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.flat_map
                  end
                end
              end

              ##
              # @param pattern [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #

              ##
              # @overload grep(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload grep(pattern, &iteration_block)
              #   @param pattern [Object]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def grep(*args, &iteration_block)
                process_as_enumerable(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.grep(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload grep_v(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload grep_v(pattern, &iteration_block)
              #   @param pattern [Object]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def grep_v(*args, &iteration_block)
                process_as_enumerable(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.grep_v(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def group_by(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.group_by(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.group_by
                  end
                end
              end

              ##
              # @param obj [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def include?(obj)
                process_as_boolean(obj, nil) do |obj|
                  enumerable.include?(obj)
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def inject(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_object(*args, iteration_block) do |*args, &step_aware_iteration_block|
                    enumerable.inject(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_object(*args) do |*args|
                    enumerable.inject(*args)
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def lazy
                process_without_block_return_lazy_enumerator do
                  enumerable.lazy
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def map(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.map(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.map
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def max(n = nil, &iteration_block)
                if n
                  if iteration_block
                    process_as_enumerable(n, iteration_block) do |n, step_aware_iteration_block|
                      enumerable.max(n, &step_aware_iteration_block)
                    end
                  else
                    process_as_enumerable(n) do |n|
                      enumerable.max(n)
                    end
                  end
                elsif iteration_block
                  process_with_block_return_object_or_nil(iteration_block) do |step_aware_iteration_block|
                    enumerable.max(&step_aware_iteration_block)
                  end
                else
                  process_without_block_return_object_or_nil do
                    enumerable.max
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def max_by(n = nil, &iteration_block)
                if n
                  if iteration_block
                    process_as_enumerable(n, iteration_block) do |n, step_aware_iteration_block|
                      enumerable.max_by(n, &step_aware_iteration_block)
                    end
                  else
                    process_as_enumerator(n) do |n|
                      enumerable.max_by(n)
                    end
                  end
                elsif iteration_block
                  process_with_block_return_object_or_nil(iteration_block) do |step_aware_iteration_block|
                    enumerable.max_by(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.max_by
                  end
                end
              end

              ##
              # @param obj [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def member?(obj)
                process_as_boolean(obj, nil) do |obj|
                  enumerable.member?(obj)
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def min(n = nil, &iteration_block)
                if n
                  if iteration_block
                    process_as_enumerable(n, iteration_block) do |n, step_aware_iteration_block|
                      enumerable.min(n, &step_aware_iteration_block)
                    end
                  else
                    process_as_enumerable(n) do |n|
                      enumerable.min(n)
                    end
                  end
                elsif iteration_block
                  process_with_block_return_object_or_nil(iteration_block) do |step_aware_iteration_block|
                    enumerable.min(&step_aware_iteration_block)
                  end
                else
                  process_without_block_return_object_or_nil do
                    enumerable.min
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def min_by(n = nil, &iteration_block)
                if n
                  if iteration_block
                    process_as_enumerable(n, iteration_block) do |n, step_aware_iteration_block|
                      enumerable.min_by(n, &step_aware_iteration_block)
                    end
                  else
                    process_as_enumerator(n) do |n|
                      enumerable.min_by(n)
                    end
                  end
                elsif iteration_block
                  process_with_block_return_object_or_nil(iteration_block) do |step_aware_iteration_block|
                    enumerable.min_by(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.min_by
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def minmax(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.minmax(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerable do
                    enumerable.minmax
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def minmax_by(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.minmax_by(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.minmax_by
                  end
                end
              end

              ##
              # @overload none?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload none?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def none?(*args, &iteration_block)
                process_as_boolean(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.none?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload one?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              # @overload one?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def one?(*args, &iteration_block)
                process_as_boolean(*args, iteration_block) do |*args, step_aware_iteration_block|
                  enumerable.one?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def partition(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.partition(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.partition
                  end
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def reduce(*args, &iteration_block)
                if iteration_block
                  process_with_block_return_object(*args, iteration_block) do |*args, &step_aware_iteration_block|
                    enumerable.reduce(*args, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_object(*args) do |*args|
                    enumerable.reduce(*args)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def reject(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.reject(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.reject
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def reverse_each(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.reverse_each(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.reverse_each
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def select(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.select(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(iteration_block) do
                    enumerable.select
                  end
                end
              end

              ##
              # @param pattern [Object, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_after(pattern, &iteration_block)
                if iteration_block
                  process_with_block_return_enumerator(iteration_block) do |step_aware_iteration_block|
                    enumerable.slice_after(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(pattern) do |pattern|
                    enumerable.slice_after(pattern)
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
                  process_with_block_return_enumerator(iteration_block) do |step_aware_iteration_block|
                    enumerable.slice_before(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator(pattern) do |pattern|
                    enumerable.slice_before(pattern)
                  end
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def slice_when(&iteration_block)
                process_with_block_return_enumerator(iteration_block) do |step_aware_iteration_block|
                  enumerable.slice_when(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def sort(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.sort(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerable do
                    enumerable.sort
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def sort_by(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.sort_by(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.sort_by
                  end
                end
              end

              ##
              # @param init [Object, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def sum(init = nil, &iteration_block)
                if iteration_block
                  process_with_block_return_object(init, iteration_block) do |init, step_aware_iteration_block|
                    enumerable.sum(init, &step_aware_iteration_block)
                  end
                else
                  process_without_block_return_object(init) do |init|
                    enumerable.sum(init)
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def take(n)
                process_as_enumerable(n) do |n|
                  enumerable.take(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def take_while(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.take_while(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.take_while
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def tally
                process_without_block_return_object do
                  enumerable.tally
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_a
                process_as_enumerable do
                  enumerable.to_a
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def to_h
                process_as_enumerable do
                  enumerable.to_h
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Base]
              #
              def uniq(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.uniq(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerable do
                    enumerable.uniq
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
                    enumerable.zip(*args, &step_aware_iteration_block)
                  end
                else
                  process_as_enumerable(*args) do |*args|
                    enumerable.zip(*args)
                  end
                end
              end

              # ...

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareCollections::Entities::StepAwareCollections::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  process_as_enumerable(iteration_block) do |step_aware_iteration_block|
                    enumerable.each(&step_aware_iteration_block)
                  end
                else
                  process_as_enumerator do
                    enumerable.each
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
