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
            class ChainEnumerator < Entities::ServiceAwareEnumerables::Enumerator
              ##
              # @api private
              #
              # @return [Enumerator::Chain]
              #
              alias_method :chain_enumerator, :object

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_chain_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    chain_enumerator.each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    chain_enumerator.each
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_cons(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_chain_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    chain_enumerator.each_cons(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    chain_enumerator.each_cons(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_entry(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_chain_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    chain_enumerator.each_entry(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    chain_enumerator.each_entry
                  end
                end
              end

              ##
              # @api public
              #
              # @param n [Integer]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_slice(n, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_chain_enumerator(arguments(n, &iteration_block)) do |n, &service_aware_iteration_block|
                    chain_enumerator.each_slice(n, &service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(n)) do |n|
                    chain_enumerator.each_slice(n)
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def each_with_index(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_chain_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    chain_enumerator.each_with_index(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    chain_enumerator.each_with_index
                  end
                end
              end

              ##
              # @api public
              #
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator, ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def reverse_each(&iteration_block)
                if iteration_block
                  with_processing_return_value_as_chain_enumerator(arguments(&iteration_block)) do |&service_aware_iteration_block|
                    chain_enumerator.reverse_each(&service_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator do
                    chain_enumerator.reverse_each
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
