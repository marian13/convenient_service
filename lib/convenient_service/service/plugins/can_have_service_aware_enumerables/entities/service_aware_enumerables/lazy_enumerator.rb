# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveServiceAwareEnumerables
        module Entities
          module ServiceAwareEnumerables
            class LazyEnumerator < Entities::ServiceAwareEnumerables::Enumerator
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.each(&service_aware_iteration_block)
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
                # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
                #
                def chain(*enums)
                  casted_enums = enums.map { |collection| cast_service_aware_enumerable(collection) }.map(&:enumerable)

                  with_processing_return_value_as_lazy_enumerator(arguments(*casted_enums)) do |*enums|
                    lazy_enumerator.chain(*enums)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def chunk(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.chunk(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def chunk_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.chunk_while(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def collect(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.collect(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def collect_concat(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.collect_concat(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def cycle(n = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    lazy_enumerator.cycle(n, &service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              # @internal
              #   TODO: Step inside `ifnode`?
              #
              def detect(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &service_aware_iteration_block|
                    lazy_enumerator.detect(ifnone, &service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def drop_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.drop_while(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def each_cons(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                  lazy_enumerator.each_cons(n, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def each_entry(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.each_entry(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def each_slice(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                  lazy_enumerator.each_slice(n, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.each_with_index(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def each_with_object(obj, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(obj, &iteration_block)) do |obj, &service_aware_iteration_block|
                    lazy_enumerator.each_with_object(obj, &service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def filter(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.filter(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def filter_map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.filter_map(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def find(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &service_aware_iteration_block|
                    enumerable.find(ifnone, &service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def find_all(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.find_all(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def find_index(*args, &iteration_block)
                if iteration_block || args.any?
                  with_processing_return_value_as_object_or_nil(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                    lazy_enumerator.find_index(*args, &service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def flat_map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.flat_map(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param pattern [Object]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def grep(pattern, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(pattern, &iteration_block)) do |pattern, &service_aware_iteration_block|
                  lazy_enumerator.grep(pattern, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param pattern [Object]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def grep_v(pattern, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(pattern, &iteration_block)) do |pattern, &service_aware_iteration_block|
                  lazy_enumerator.grep_v(pattern, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Hash, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def group_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_hash(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.group_by(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def map(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.map(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def max_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                      lazy_enumerator.max_by(n, &service_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                      lazy_enumerator.max_by(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def min_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                      lazy_enumerator.min_by(n, &service_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                      lazy_enumerator.min_by(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def minmax(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.minmax(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def minmax_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.minmax_by(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def partition(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.partition(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def reject(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.reject(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def reverse_each(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.reverse_each(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def select(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.select(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def slice_after(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  lazy_enumerator.slice_after(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def slice_before(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  lazy_enumerator.slice_before(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def slice_when(*args, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  lazy_enumerator.slice_when(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def sort_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.sort_by(&service_aware_iteration_block)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def take(n, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                  lazy_enumerator.take(n, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def take_while(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.take_while(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def uniq(&iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  lazy_enumerator.uniq(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param offset [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def with_index(offset = nil, &iteration_block)
                with_processing_return_value_as_lazy_enumerator(arguments(offset, &iteration_block)) do |offset, &service_aware_iteration_block|
                  lazy_enumerator.with_index(offset, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def zip(*args, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                    lazy_enumerator.zip(*args, &service_aware_iteration_block)
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
