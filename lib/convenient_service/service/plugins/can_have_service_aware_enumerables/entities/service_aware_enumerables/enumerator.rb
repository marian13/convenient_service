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
            class Enumerator < Entities::ServiceAwareEnumerables::Enumerable
              ##
              # @api private
              #
              # @return [Enumerator]
              #
              alias_method :enumerator, :object

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
              # @return [Symbol]
              #
              def default_evaluate_by
                :to_a
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
              #
              def each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerator.each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerator.each
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_cons(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerator.each_cons(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerator.each_cons(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_entry(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerator.each_entry(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerator.each_entry
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_slice(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    enumerator.each_slice(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    enumerator.each_slice(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerator.each_with_index(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerator.each_with_index
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def reverse_each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    enumerator.reverse_each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    enumerator.reverse_each
                  end
                end
              end

              ##
              # @api public
              #
              # @param offset [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def with_index(offset = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(offset, &iteration_block)) do |offset, &service_aware_iteration_block|
                    enumerator.with_index(offset, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(offset)) do |offset|
                    enumerator.with_index(offset)
                  end
                end
              end

              ##
              # @api public
              #
              # @param offset [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def service_aware_with_index(offset = nil, &iteration_block)
                with_index(offset, &service_aware_iteration_block_from(iteration_block))
              end

              ##
              # @api public
              #
              # @param obj [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def with_object(obj, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_object(arguments(obj, &iteration_block)) do |obj, &service_aware_iteration_block|
                    enumerator.with_object(obj, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(obj)) do |obj|
                    enumerator.with_object(obj)
                  end
                end
              end

              ##
              # @api public
              #
              # @param obj [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def service_aware_with_object(obj, &iteration_block)
                with_object(obj, &service_aware_iteration_block_from(iteration_block))
              end
            end
          end
        end
      end
    end
  end
end
