# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

return unless ConvenientService::Dependencies.ruby.match?("jruby < 10.1")

module ConvenientService
  module Service
    module Plugins
      module CanHaveServiceAwareEnumerables
        module Entities
          module ServiceAwareEnumerables
            class LazyEnumerator < Entities::ServiceAwareEnumerables::Enumerator
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
                    lazy_enumerator.detect(ifnone, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(ifnone)) do |ifnone|
                    lazy_enumerator.detect(ifnone)
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
                    lazy_enumerator.each_with_index(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.each_with_index
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
                    lazy_enumerator.find(ifnone)
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
                    lazy_enumerator.find_index(*args, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.find_index
                  end
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
                    lazy_enumerator.group_by(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.group_by
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
                      lazy_enumerator.max_by(n, &service_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                      lazy_enumerator.max_by(&service_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.max_by
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
                      lazy_enumerator.min_by(n, &service_aware_iteration_block)
                    end
                  else
                    with_processing_return_value_as_object_or_nil(arguments(&iteration_block)) do |&service_aware_iteration_block|
                      lazy_enumerator.min_by(&service_aware_iteration_block)
                    end
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.min_by
                  end
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
                    lazy_enumerator.minmax_by(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.minmax_by
                  end
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
                    lazy_enumerator.partition(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.partition
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
                  with_processing_return_value_as_lazy_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    lazy_enumerator.reverse_each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.reverse_each
                  end
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
                    lazy_enumerator.sort_by(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    lazy_enumerator.sort_by
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
