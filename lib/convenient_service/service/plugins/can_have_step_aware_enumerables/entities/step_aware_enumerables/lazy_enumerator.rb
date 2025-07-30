# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class LazyEnumerator < Entities::StepAwareEnumerables::Enumerator
              ##
              # @api private
              #
              # @return [Enumerator::Lazy]
              #
              alias_method :lazy_enumerator, :object

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    lazy_enumerator.each(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.each
                  end
                end
              end

              if Dependencies.ruby.version >= 3.1
                ##
                # @api public
                #
                # @param enums [Array<Enumerable>]
                # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
                #
                def chain(*enums)
                  casted_enums = enums.map { |collection| cast_step_aware_enumerable(collection) }.map(&:enumerable)

                  with_processing_return_value_as_lazy_enumerator(arguments(*casted_enums)) do |*enums|
                    lazy_enumerator.chain(*enums)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def chunk(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.chunk(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def chunk_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.chunk_while(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def collect(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.collect(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def collect_concat(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.collect_concat(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def compact
                with_processing_return_value_as_lazy_enumerator do
                  lazy_enumerator.compact
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def cycle(n = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                    lazy_enumerator.cycle(n, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator(arguments(n)) do |n|
                    lazy_enumerator.cycle(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              # @internal
              #   TODO: Step inside `ifnode`?
              #
              def detect(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &step_aware_iteration_block|
                    lazy_enumerator.detect(ifnone, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator(arguments(ifnone)) do |ifnone|
                    lazy_enumerator.detect(ifnone)
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def drop(n)
                with_processing_return_value_as_lazy_enumerator(arguments(n)) do |n|
                  lazy_enumerator.drop(n)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def drop_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.drop_while(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def each_cons(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                  lazy_enumerator.each_cons(n, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def each_entry(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.each_entry(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def each_slice(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                  lazy_enumerator.each_slice(n, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    lazy_enumerator.each_with_index(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.each_with_index
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def each_with_object(obj, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(obj, &iteration_block)) do |obj, &step_aware_iteration_block|
                    lazy_enumerator.each_with_object(obj, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator(arguments(obj)) do |obj|
                    lazy_enumerator.each_with_object(obj)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def filter(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.filter(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def filter_map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.filter_map(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def find(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &step_aware_iteration_block|
                    enumerable.find(ifnone, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator(arguments(ifnone)) do |ifnone|
                    lazy_enumerator.find(ifnone)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def find_all(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.find_all(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def find_index(*args, &iteration_block)
                if iteration_block || args.any?
                  with_processing_return_value_as_object_or_nil(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                    lazy_enumerator.find_index(*args, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.find_index
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def flat_map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.flat_map(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param pattern [Object]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def grep(pattern, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(pattern, &iteration_block)) do |pattern, &step_aware_iteration_block|
                  lazy_enumerator.grep(pattern, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param pattern [Object]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def grep_v(pattern, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(pattern, &iteration_block)) do |pattern, &step_aware_iteration_block|
                  lazy_enumerator.grep_v(pattern, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Hash, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def group_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_hash(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    lazy_enumerator.group_by(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.group_by
                  end
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def lazy
                with_processing_return_value_as_lazy_enumerator do
                  lazy_enumerator.lazy
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.map(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def max_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                      lazy_enumerator.max_by(n, &step_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&step_aware_iteration_block|
                      lazy_enumerator.max_by(&step_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.max_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def min_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                      lazy_enumerator.min_by(n, &step_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&step_aware_iteration_block|
                      lazy_enumerator.min_by(&step_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.min_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def minmax(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.minmax(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def minmax_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    lazy_enumerator.minmax_by(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.minmax_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def partition(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    lazy_enumerator.partition(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.partition
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def reject(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.reject(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def reverse_each(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.reverse_each(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def select(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.select(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def slice_after(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.slice_after(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def slice_before(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.slice_before(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def slice_when(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                  lazy_enumerator.slice_when(*args, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def sort_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&step_aware_iteration_block|
                    lazy_enumerator.sort_by(&step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator do
                    lazy_enumerator.sort_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def take(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &step_aware_iteration_block|
                  lazy_enumerator.take(n, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def take_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.take_while(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def uniq(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  lazy_enumerator.uniq(&step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param offset [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_index(offset = nil, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(offset, &iteration_block)) do |offset, &step_aware_iteration_block|
                  lazy_enumerator.with_index(offset, &step_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def zip(*args, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &step_aware_iteration_block|
                    lazy_enumerator.zip(*args, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_lazy_enumerator(arguments(*args)) do |*args|
                    lazy_enumerator.zip(*args)
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

require_relative "lazy_enumerator/jruby"
