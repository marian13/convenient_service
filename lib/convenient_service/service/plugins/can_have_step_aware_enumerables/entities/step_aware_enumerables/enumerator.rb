# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class Enumerator < Entities::StepAwareEnumerables::Enumerable
              ##
              # @api private
              #
              # @return [Enumerator]
              #
              alias_method :enumerator, :object

              ##
              # @api private
              #
              # @return [Enumerator]
              #
              alias_method :enumerable, :enumerator

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
              # @param offset [Integer, nil]
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def with_index(offset = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(offset, &iteration_block)) do |offset, &step_aware_iteration_block|
                    enumerator.with_index(offset, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(offset)) do |offset|
                    enumerator.with_index(offset)
                  end
                end
              end

              def with_index(offset = nil, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(offset, &iteration_block)) do |offset, &step_aware_iteration_block|
                    ##
                    # TODO: Refactor.
                    #
                    if modifiers.any?
                      old_modifier = modifiers.pop

                      modifier = modifier_for(old_modifier[:n], step_aware_iteration_block)

                      modifier[:pre_iterator_block].call

                      values = enumerator.with_index(offset, &modifier[:iteration_block])

                      modifier[:post_iterator_block].call

                      values
                    else
                      enumerator.with_index(offset, &step_aware_iteration_block)
                    end
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
              # @param obj [Object] Can be any type.
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable, ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def with_object(obj, &iteration_block)
                if iteration_block
                  with_processing_return_value_as_enumerable(arguments(obj, &iteration_block), method: :with_object) do |obj, &step_aware_iteration_block|
                    enumerator.with_object(obj, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(obj), method: :with_object) do |obj|
                    enumerator.with_object(obj)
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
