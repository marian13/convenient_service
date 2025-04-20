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
                  with_processing_return_value_as_enumerable(arguments(offset, &iteration_block), allow_modifier: true) do |offset, &step_aware_iteration_block|
                    enumerator.with_index(offset, &step_aware_iteration_block)
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
                  with_processing_return_value_as_object(arguments(obj, &iteration_block), allow_modifier: true) do |obj, &step_aware_iteration_block|
                    enumerator.with_object(obj, &step_aware_iteration_block)
                  end
                else
                  with_processing_return_value_as_enumerator(arguments(obj)) do |obj|
                    enumerator.with_object(obj)
                  end
                end
              end

              private

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param allow_modifier [Boolean]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_enumerable(iterator_arguments = Support::Arguments.null_arguments, allow_modifier: false, &iterator_block)
                super(iterator_arguments) do |*args, &step_aware_iteration_block|
                  next iterator_block.call(*args, &step_aware_iteration_block) unless allow_modifier
                  next iterator_block.call(*args, &step_aware_iteration_block) if modifiers.none?

                  ##
                  # TODO: `dup`.
                  #
                  old_modifier = modifiers.pop

                  modifier = modifier_for(old_modifier[:n], step_aware_iteration_block)

                  modifier[:pre_iterator_block].call

                  values = iterator_block.call(*args, &modifier[:iteration_block])

                  modifier[:post_iterator_block].call

                  values
                end
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param allow_modifier [Boolean]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_object(iterator_arguments = Support::Arguments.null_arguments, allow_modifier: false, &iterator_block)
                super(iterator_arguments) do |*args, &step_aware_iteration_block|
                  next iterator_block.call(*args, &step_aware_iteration_block) unless allow_modifier
                  next iterator_block.call(*args, &step_aware_iteration_block) if modifiers.none?

                  ##
                  # TODO: `dup`.
                  #
                  old_modifier = modifiers.pop

                  modifier = modifier_for(old_modifier[:n], step_aware_iteration_block)

                  modifier[:pre_iterator_block].call

                  values = iterator_block.call(*args, &modifier[:iteration_block])

                  modifier[:post_iterator_block].call

                  values
                end
              end
            end
          end
        end
      end
    end
  end
end
