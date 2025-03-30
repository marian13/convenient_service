# frozen_string_literal: true

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

              private

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_enumerator(...)
                with_processing_return_value_as_lazy_enumerator(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_enumerator_generator(...)
                with_processing_return_value_as_lazy_enumerator(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_chain_enumerator(...)
                with_processing_return_value_as_lazy_enumerator(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_exactly_enumerator(...)
                with_processing_return_value_as_exactly_lazy_enumerator(...)
              end
            end
          end
        end
      end
    end
  end
end
