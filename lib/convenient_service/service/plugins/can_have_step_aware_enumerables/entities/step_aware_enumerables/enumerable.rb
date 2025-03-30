# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class Enumerable < Entities::StepAwareEnumerables::Base
              ##
              # @api private
              #
              # @return [Enumerable]
              #
              alias_method :enumerable, :object

              ##
              # @api private
              #
              # @return [Symbol]
              #
              def default_data_key
                :values
              end

              ##
              # @api private
              #
              # @return [nil]
              #
              def default_evaluate_by
                nil
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.each(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.each
                  end
                end
              end

              ##
              # @overload all?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload all?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def all?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.all?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload any?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload any?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def any?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.any?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param enums [Array<Enumerable>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def chain(*enums)
                casted_enums = enums.map { |collection| cast_step_aware_enumerable(collection) }.map(&:enumerable)

                with_processing_return_value_as_chain_enumerator(arguments(*casted_enums)) do |*enums|
                  enumerable.chain(*enums)
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def chunk(&iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.chunk(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def chunk_while(&iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.chunk_while(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def collect(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_array(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.collect(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.collect
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def collect_concat(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_array(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.collect_concat(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do
                    enumerable.collect_concat
                  end
                end
              end

              if Dependencies.ruby.version >= 3.1
                ##
                # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
                #
                def compact
                  with_processing_return_value_as_enumerable do
                    enumerable.compact
                  end
                end
              end

              ##
              # @overload count
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload count(item)
              #   @param item [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload count(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def count(*args, &iteration_block)
                with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.count(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def cycle(n = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                    enumerable.cycle(n, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerable.cycle(n)
                  end
                end
              end

              ##
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def detect(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &step_aware_iteration_block|
                    enumerable.detect(ifnone, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(ifnone)) do |ifnone|
                    enumerable.detect(ifnone)
                  end
                end
              end

              ##
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def drop(n)
                with_processing_return_value_as_enumerable(arguments(n)) do |n|
                  enumerable.drop(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def drop_while(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.drop_while(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.drop_while
                  end
                end
              end

              ##
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def each_cons(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                    enumerable.each_cons(n, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerable.each_cons(n)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def each_entry(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.each_entry(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.each_entry
                  end
                end
              end

              ##
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def each_slice(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                    enumerable.each_slice(n, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerable.each_slice(n)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.each_with_index(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.each_with_index
                  end
                end
              end

              ##
              # @param obj [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def each_with_object(obj, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(obj, &iteration_block)) do |obj, &step_aware_iteration_block|
                    enumerable.each_with_object(obj, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(obj)) do |obj|
                    enumerable.each_with_object(obj)
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def entries
                with_processing_return_value_as_enumerable do
                  enumerable.entries
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def filter(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.filter(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.filter
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def filter_map(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.filter_map(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.filter_map
                  end
                end
              end

              ##
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def find(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &step_aware_iteration_block|
                    enumerable.find(ifnone, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(ifnone)) do |ifnone|
                    enumerable.find(ifnone)
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def find_all(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.find_all(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do
                    enumerable.find_all
                  end
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def find_index(*args, &iteration_block)
                if iteration_block || args.any?
                  with_processing_return_value_as_object_or_nil(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                    enumerable.find_index(*args, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.find_index
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def first(n = nil)
                if n
                  with_processing_return_value_as_enumerable(arguments(n)) do |n|
                    enumerable.first(n)
                  end
                else
                  with_processing_return_value_as_object_or_nil do
                    enumerable.first
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def flat_map(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.flat_map(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do
                    enumerable.flat_map
                  end
                end
              end

              ##
              # @overload grep(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload grep(pattern, &iteration_block)
              #   @param pattern [Object]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def grep(*args, &iteration_block)
                with_processing_return_value_as_enumerable(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.grep(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload grep_v(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload grep_v(pattern, &iteration_block)
              #   @param pattern [Object]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def grep_v(*args, &iteration_block)
                with_processing_return_value_as_enumerable(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.grep_v(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def group_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_hash(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.group_by(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.group_by
                  end
                end
              end

              ##
              # @param obj [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def include?(obj)
                with_processing_return_value_as_boolean(arguments(obj)) do |obj|
                  enumerable.include?(obj)
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def inject(*args, &iteration_block)
                with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.inject(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def lazy
                with_processing_return_value_as_lazy_enumerator do
                  enumerable.lazy
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def map(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.map(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.map
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def max(n = nil, &iteration_block)
                if n
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                    enumerable.max(n, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.max(&step_aware_iteration_block)
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def max_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                      enumerable.max_by(n, &step_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&step_aware_iteration_block|
                      enumerable.max_by(&step_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.max_by
                  end
                end
              end

              ##
              # @param obj [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def member?(obj)
                with_processing_return_value_as_boolean(arguments(obj)) do |obj|
                  enumerable.member?(obj)
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def min(n = nil, &iteration_block)
                if n
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                    enumerable.min(n, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.min(&step_aware_iteration_block)
                  end
                end
              end

              ##
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def min_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                      enumerable.min_by(n, &step_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&step_aware_iteration_block|
                      enumerable.min_by(&step_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.min_by
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def minmax(&iteration_block)
                with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.minmax(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def minmax_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.minmax_by(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.minmax_by
                  end
                end
              end

              ##
              # @overload none?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload none?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def none?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.none?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload one?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload one?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def one?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.one?(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def partition(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.partition(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.partition
                  end
                end
              end

              ##
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def reduce(*args, &iteration_block)
                with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.reduce(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def reject(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.reject(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.reject
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def reverse_each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.reverse_each(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.reverse_each
                  end
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def select(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.select(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.select
                  end
                end
              end

              ##
              # @overload slice_after(pattern)
              #   @param pattern [Object] Can be any type.
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload slice_after(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def slice_after(*args, &iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.slice_after(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @overload slice_before(pattern)
              #   @param pattern [Object] Can be any type.
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload slice_before(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def slice_before(*args, &iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  enumerable.slice_before(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def slice_when(&iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.slice_when(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def sort(&iteration_block)
                with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.sort(&step_aware_iteration_block)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def sort_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.sort_by(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.sort_by
                  end
                end
              end

              ##
              # @overload sum
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload sum(init)
              #   @param init [Integer]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload sum(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              # @overload sum(init, &iteration_block)
              #   @param init [Integer]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def sum(init = 0, &iteration_block)
                with_processing_return_value_as_object(arguments(init, &iteration_block)) do |init, &step_aware_iteration_block|
                  enumerable.sum(init, &step_aware_iteration_block)
                end
              end

              ##
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def take(n)
                with_processing_return_value_as_enumerable(arguments(n)) do |n|
                  enumerable.take(n)
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def take_while(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.take_while(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.take_while
                  end
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def tally
                with_processing_return_value_as_hash do
                  enumerable.tally
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def to_a
                with_processing_return_value_as_array do
                  enumerable.to_a
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def to_h
                with_processing_return_value_as_hash do
                  enumerable.to_h
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def to_set
                with_processing_return_value_as_set do
                  enumerable.to_set
                end
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def uniq(&iteration_block)
                with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.uniq(&step_aware_iteration_block)
                end
              end

              ##
              # @param other_enums [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def zip(*other_enums, &iteration_block)
                casted_other_enums = other_enums.map { |collection| cast_step_aware_enumerable(collection) }.map(&:enumerable)

                if iteration_block
                  with_processing_return_value_as_object(arguments(*casted_other_enums, &iteration_block)) do |*other_enums, &step_aware_iteration_block|
                    enumerable.zip(*other_enums, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerable(arguments(*casted_other_enums)) do |*other_enums|
                    enumerable.zip(*other_enums)
                  end
                end
              end

              ##
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def select_exactly(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_exactly_enumerable(n, arguments(&iteration_block)) do |&step_aware_iteration_block|
                    enumerable.select(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_exactly_enumerator(n) do
                    enumerable.select
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
