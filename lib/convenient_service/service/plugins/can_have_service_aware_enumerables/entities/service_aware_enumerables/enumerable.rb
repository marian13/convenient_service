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
            class Enumerable < Entities::ServiceAwareEnumerables::Base
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
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.each
                  end
                end
              end

              ##
              # @api public
              #
              # @overload all?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload all?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def all?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.all?(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @overload any?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload any?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def any?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.any?(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param enums [Array<Enumerable>]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def chain(*enums)
                casted_enums = enums.map { |collection| cast_service_aware_enumerable(collection) }.map(&:enumerable)

                with_processing_return_value_as_chain_enumerator(arguments(*casted_enums)) do |*enums|
                  enumerable.chain(*enums)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def chunk(&iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  enumerable.chunk(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def chunk_while(&iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  enumerable.chunk_while(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def collect(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_array(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.collect(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.collect
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def collect_concat(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_array(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.collect_concat(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do
                    enumerable.collect_concat
                  end
                end
              end

              if Dependencies.ruby.version >= 3.1
                ##
                # @api public
                #
                # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
                #
                def compact
                  with_processing_return_value_as_enumerable do
                    enumerable.compact
                  end
                end
              end

              ##
              # @api public
              #
              # @overload count
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload count(item)
              #   @param item [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload count(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def count(*args, &iteration_block)
                with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.count(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def cycle(n = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerable.cycle(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerable.cycle(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def detect(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &service_aware_iteration_block|
                    enumerable.detect(ifnone, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(ifnone)) do |ifnone|
                    enumerable.detect(ifnone)
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def drop(n)
                with_processing_return_value_as_enumerable(arguments(n)) do |n|
                  enumerable.drop(n)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def drop_while(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.drop_while(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.drop_while
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def each_cons(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerable.each_cons(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerable.each_cons(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def each_entry(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.each_entry(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.each_entry
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def each_slice(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerable.each_slice(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerable.each_slice(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.each_with_index(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.each_with_index
                  end
                end
              end

              ##
              # @api public
              #
              # @param obj [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def each_with_object(obj, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(obj, &iteration_block)) do |obj, &service_aware_iteration_block|
                    enumerable.each_with_object(obj, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(obj)) do |obj|
                    enumerable.each_with_object(obj)
                  end
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def entries
                with_processing_return_value_as_enumerable do
                  enumerable.entries
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def filter(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.filter(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.filter
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def filter_map(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.filter_map(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.filter_map
                  end
                end
              end

              ##
              # @api public
              #
              # @param ifnone [Proc, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def find(ifnone = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object_or_nil(arguments(ifnone, &iteration_block)) do |ifnone, &service_aware_iteration_block|
                    enumerable.find(ifnone, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(ifnone)) do |ifnone|
                    enumerable.find(ifnone)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def find_all(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.find_all(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do
                    enumerable.find_all
                  end
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def find_index(*args, &iteration_block)
                if iteration_block || args.any?
                  with_processing_return_value_as_object_or_nil(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                    enumerable.find_index(*args, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.find_index
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
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
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def flat_map(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.flat_map(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do
                    enumerable.flat_map
                  end
                end
              end

              ##
              # @api public
              #
              # @overload grep(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload grep(pattern, &iteration_block)
              #   @param pattern [Object]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def grep(*args, &iteration_block)
                with_processing_return_value_as_enumerable(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.grep(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @overload grep_v(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload grep_v(pattern, &iteration_block)
              #   @param pattern [Object]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def grep_v(*args, &iteration_block)
                with_processing_return_value_as_enumerable(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.grep_v(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def group_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_hash(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.group_by(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.group_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param obj [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def include?(obj)
                with_processing_return_value_as_boolean(arguments(obj)) do |obj|
                  enumerable.include?(obj)
                end
              end

              if Dependencies.ruby.version > 3.0
                ##
                # @api public
                #
                # @param args [Array<Object>]
                # @param iteration_block [Proc, nil]
                # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
                #
                def inject(*args, &iteration_block)
                  with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                    enumerable.inject(*args, &service_aware_iteration_block)
                  end
                end
              else
                ##
                # @api public
                #
                # @param args [Array<Object>]
                # @param kwargs [Hash{Symbol => Object}]
                # @param iteration_block [Proc, nil]
                # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
                #
                def inject(*args, **kwargs, &iteration_block)
                  with_processing_return_value_as_object(arguments(*args, **kwargs, &iteration_block)) do |*args, **kwargs, &service_aware_iteration_block|
                    enumerable.inject(*args, **kwargs, &service_aware_iteration_block)
                  end
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def lazy
                with_processing_return_value_as_lazy_enumerator do
                  enumerable.lazy
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def map(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.map(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.map
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def max(n = nil, &iteration_block)
                if n
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerable.max(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.max(&service_aware_iteration_block)
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def max_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                      enumerable.max_by(n, &service_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                      enumerable.max_by(&service_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.max_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param obj [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def member?(obj)
                with_processing_return_value_as_boolean(arguments(obj)) do |obj|
                  enumerable.member?(obj)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def min(n = nil, &iteration_block)
                if n
                  with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerable.min(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.min(&service_aware_iteration_block)
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def min_by(n = nil, &iteration_block)
                if iteration_block
                  if n
                    with_processing_return_value_as_enumerable(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                      enumerable.min_by(n, &service_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                      enumerable.min_by(&service_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.min_by
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def minmax(&iteration_block)
                with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  enumerable.minmax(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def minmax_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.minmax_by(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.minmax_by
                  end
                end
              end

              ##
              # @api public
              #
              # @overload none?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload none?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def none?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.none?(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @overload one?(pattern)
              #   @param pattern [Object]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload one?(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def one?(*args, &iteration_block)
                with_processing_return_value_as_boolean(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.one?(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def partition(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.partition(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.partition
                  end
                end
              end

              if Dependencies.ruby.version > 3.0
                ##
                # @api public
                #
                # @param args [Array<Object>]
                # @param iteration_block [Proc, nil]
                # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
                #
                def reduce(*args, &iteration_block)
                  with_processing_return_value_as_object(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                    enumerable.reduce(*args, &service_aware_iteration_block)
                  end
                end
              else
                ##
                # @api public
                #
                # @param args [Array<Object>]
                # @param kwargs [Hash{Symbol => Object}]
                # @param iteration_block [Proc, nil]
                # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
                #
                def reduce(*args, **kwargs, &iteration_block)
                  with_processing_return_value_as_object(arguments(*args, **kwargs, &iteration_block)) do |*args, **kwargs, &service_aware_iteration_block|
                    enumerable.reduce(*args, **kwargs, &service_aware_iteration_block)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def reject(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.reject(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.reject
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def reverse_each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.reverse_each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.reverse_each
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def select(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.select(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.select
                  end
                end
              end

              ##
              # @api public
              #
              # @overload slice_after(pattern)
              #   @param pattern [Object] Can be any type.
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload slice_after(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def slice_after(*args, &iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.slice_after(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @overload slice_before(pattern)
              #   @param pattern [Object] Can be any type.
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload slice_before(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def slice_before(*args, &iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.slice_before(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def slice_when(&iteration_block)
                with_processing_return_value_as_enumerator_generator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  enumerable.slice_when(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def sort(&iteration_block)
                with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  enumerable.sort(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def sort_by(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.sort_by(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.sort_by
                  end
                end
              end

              ##
              # @api public
              #
              # @overload sum
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload sum(init)
              #   @param init [Integer]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload sum(&iteration_block)
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @overload sum(init, &iteration_block)
              #   @param init [Integer]
              #   @param iteration_block [Proc]
              #   @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def sum(init = 0, &iteration_block)
                with_processing_return_value_as_object(arguments(init, &iteration_block)) do |init, &service_aware_iteration_block|
                  enumerable.sum(init, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param n [Integer, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def take(n)
                with_processing_return_value_as_enumerable(arguments(n)) do |n|
                  enumerable.take(n)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def take_while(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerable.take_while(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerable.take_while
                  end
                end
              end

              ##
              # @api public
              #
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def tally
                with_processing_return_value_as_hash do
                  enumerable.tally
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @internal
              #   TODO: Specs for arguments.
              #
              def to_a(*args, &iteration_block)
                with_processing_return_value_as_array(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.to_a(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              # @internal
              #   TODO: Specs for arguments.
              #
              def to_h(*args, &iteration_block)
                with_processing_return_value_as_hash(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.to_h(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param args [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def to_set(*args, &iteration_block)
                with_processing_return_value_as_set(arguments(*args, &iteration_block)) do |*args, &service_aware_iteration_block|
                  enumerable.to_set(*args, &service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def uniq(&iteration_block)
                with_processing_return_value_as_enumerable(arguments(&iteration_block)) do |&service_aware_iteration_block|
                  enumerable.uniq(&service_aware_iteration_block)
                end
              end

              ##
              # @api public
              #
              # @param other_enums [Array<Object>]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def zip(*other_enums, &iteration_block)
                casted_other_enums = other_enums.map { |collection| cast_service_aware_enumerable(collection) }.map(&:enumerable)

                if iteration_block
                  with_processing_return_value_as_object(arguments(*casted_other_enums, &iteration_block)) do |*other_enums, &service_aware_iteration_block|
                    enumerable.zip(*other_enums, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerable(arguments(*casted_other_enums)) do |*other_enums|
                    enumerable.zip(*other_enums)
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
