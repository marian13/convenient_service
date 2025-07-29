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
            class Base
              include Support::AbstractMethod

              ##
              # @api private
              #
              # @!attribute [r] object
              #   @return [Object] Can be any type.
              #
              attr_reader :object

              ##
              # @api private
              #
              # @!attribute [r] organizer
              #   @return [ConvenientService::Service]
              #
              attr_reader :organizer

              ##
              # @api private
              #
              # @!attribute [r] propagated_result
              #   @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              #
              attr_accessor :propagated_result

              ##
              # @api private
              #
              # @!attribute [r] modifiers
              #   @return [Array<Object>]
              #
              attr_accessor :modifiers

              ##
              # @api private
              #
              # @return [Symbol, nil]
              #
              abstract_method :default_data_key

              ##
              # @api private
              #
              # @return [Symbol, String, Proc, nil]
              #
              abstract_method :evaluate_by

              ##
              # @api private
              #
              # @param object [Object] Can be any type.
              # @param organizer [ConvenientService::Service]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [void]
              #
              def initialize(object:, organizer:, propagated_result:, modifiers: [])
                @object = object
                @organizer = organizer
                @propagated_result = propagated_result
                @modifiers = modifiers
              end

              ##
              # @param data_key [Symbol, nil]
              # @param evaluate_by [String, Symbol, Proc]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: default_data_key, evaluate_by: default_evaluate_by)
                with_propagated_result_returning(evaluate_by) do |values|
                  data_key ? success(data_key => values) : success
                end
              end

              ##
              # @param other [Object] Can be any type.
              # @return [Boolean, nil]
              #
              def ==(other)
                return unless other.instance_of?(self.class)

                return false if object != other.object
                return false if organizer != other.organizer
                return false if propagated_result != other.propagated_result

                true
              end

              private

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_object(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_object_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_object_or_nil(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_object_or_nil_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_boolean(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_boolean_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_enumerable(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_enumerable_from(value, propagated_result) }
              end

              ##
              # @param n [Integer]
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def with_processing_return_value_as_exactly_enumerable(n, iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_exactly_return_value(n, iterator_arguments, iterator_block) { |value, propagated_result, modifiers| step_aware_enumerable_from(value, propagated_result, modifiers) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_array(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_array_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_hash(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_hash_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value_as_set(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_set_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def with_processing_return_value_as_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_enumerator_from(value, propagated_result) }
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              alias_method :with_processing_return_value_as_enumerator_generator, :with_processing_return_value_as_enumerator

              ##
              # @param n [Integer]
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def with_processing_return_value_as_exactly_enumerator(n, iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_exactly_return_value(n, iterator_arguments, iterator_block) { |value, propagated_result, modifiers| step_aware_enumerator_from(value, propagated_result, modifiers) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_lazy_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_lazy_enumerator_from(value, propagated_result) }
              end

              ##
              # @param n [Integer]
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_exactly_lazy_enumerator(n, iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_exactly_return_value(n, iterator_arguments, iterator_block) { |value, propagated_result, modifiers| step_aware_lazy_enumerator_from(value, propagated_result, modifiers) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ChainEnumerator]
              #
              def with_processing_return_value_as_chain_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| step_aware_chain_enumerator_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ArithmeticSequenceEnumerator]
              #
              def with_processing_return_value_as_arithmetic_sequence_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(arguments, iterator_block) { |value, propagated_result| step_aware_arithmetic_sequence_enumerator_from(value, propagated_result) }
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [Proc]
              #
              def step_aware_iteration_block_from(iteration_block)
                return unless iteration_block

                proc do |*args|
                  value = iteration_block.call(*args)

                  next value unless Plugins::CanHaveSteps.step?(value)

                  if value.success?
                    next true if value.outputs.none?

                    ##
                    # NOTE: It may look very appealing to return data objects instead of hashes. For example:
                    #   # With hashes.
                    #   result =
                    #     step_aware_enumerable(users)
                    #       .map { |user| step ProcessUser, in: :user, out: [:attributes, :associations] }
                    #       .each { |values| p [values[:attributes], values[:associations]] }
                    #       .result(data_key: :items)
                    #
                    #   result.data[:items]
                    #   # => [{attributes: {}, associations: []}, {attributes: {}, associations: []}]
                    #
                    #   # With data objects.
                    #   result =
                    #     step_aware_enumerable(users)
                    #       .map { |user| step ProcessUser, in: :user, out: [:attributes, :associations] }
                    #       .each { |data| p [data.attributes, data.associations] }
                    #       .result(data_key: :items)
                    #
                    #   result.data[:items]
                    #   # => [<...Data attributes: {}, associations: []>, <...Data attributes: {}, associations: []>]
                    #
                    #   But:
                    #   - Is it OK to return nested data objects from results?
                    #   - If not, how can those nested data objects be efficiently converted into hashes only for the results (data may return arrays, hashes, sets, enumerators, arithmetic sequences, etc.)?
                    #
                    # next value.outputs.one? ? value.output_values.values.first : value.result.create_data(value.output_values)

                    next value.outputs.one? ? value.output_values.values.first : value.output_values
                  end

                  if value.failure?
                    next value.outputs.none? ? false : nil
                  end

                  throw :propagated_result, {propagated_result: value.result}
                end
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def step_aware_object_from(object, propagated_result, modifiers = self.modifiers)
                # TODO: Cast.
                Entities::StepAwareEnumerables::Object.new(object: object, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def step_aware_object_or_nil_from(object, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Object.new(object: object, organizer: organizer, propagated_result: propagated_result || (failure unless object), modifiers: modifiers)
              end

              ##
              # @param boolean [Boolean].
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def step_aware_boolean_from(boolean, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Boolean.new(object: boolean, organizer: organizer, propagated_result: propagated_result || (failure unless object), modifiers: modifiers)
              end

              ##
              # @param enumerable [Enumerable]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_enumerable_from(enumerable, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Enumerable.new(object: enumerable, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param array [Array]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_array_from(array, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Array.new(object: array, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param hash [Hash]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_hash_from(hash, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Hash.new(object: hash, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param set [Set]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_set_from(set, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Set.new(object: set, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def step_aware_enumerator_from(enumerator, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::Enumerator.new(object: enumerator, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param lazy_enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def step_aware_lazy_enumerator_from(lazy_enumerator, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::LazyEnumerator.new(object: lazy_enumerator, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param chain_enumerator [Enumerator::Chain]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ChainEnumerator]
              #
              def step_aware_chain_enumerator_from(chain_enumerator, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::ChainEnumerator.new(object: chain_enumerator, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param arithmetic_sequence_enumerator [Enumerator::ArithmeticSequence]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @param modifiers [Array<Object>]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ArithmeticSequence::Enumerator]
              #
              def step_aware_arithmetic_sequence_enumerator_from(arithmetic_sequence_enumerator, propagated_result, modifiers = self.modifiers)
                Entities::StepAwareEnumerables::ArithmeticSequenceEnumerator.new(object: arithmetic_sequence_enumerator, organizer: organizer, propagated_result: propagated_result, modifiers: modifiers)
              end

              ##
              # @param n [Integer]
              # @param step_aware_iteration_block [Proc, nil]
              # @return [Hash{Symbol => Proc, nil}]
              #
              def modifier_for(n, step_aware_iteration_block)
                iterator_details = {match_count: 0}

                {
                  n: n,
                  iterator_details: iterator_details,
                  pre_iterator_block: proc { throw :propagated_result, {propagated_result: error} if n < 0 },
                  post_iterator_block: proc { throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] != n },
                  iteration_block: modifier_iteration_block_for(n, iterator_details, step_aware_iteration_block)
                }
              end

              ##
              # @param n [Integer]
              # @param iterator_details [Hash{Symbol => Object}]
              # @param step_aware_iteration_block [Proc, nil]
              # @return [Proc, nil]
              #
              def modifier_iteration_block_for(n, iterator_details, step_aware_iteration_block)
                return unless step_aware_iteration_block

                proc do |*args|
                  value = step_aware_iteration_block.call(*args)

                  iterator_details[:match_count] += 1 if value

                  throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] > n

                  value
                end
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def success(...)
                organizer.success(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def failure(...)
                organizer.failure(...)
              end

              ##
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def error(...)
                organizer.error(...)
              end

              ##
              # @return [ConvenientService::Support::Arguments]
              #
              def arguments(...)
                Support::Arguments.new(...)
              end

              ##
              # @param object [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Base]
              #
              def cast_step_aware_enumerable(object)
                Commands::CastStepAwareEnumerable.call(object: object, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param value [Symbol, String, Proc, nil]
              # @return [Proc]
              #
              def cast_evaluate_by_block(value)
                return proc { |enumerable| enumerable.public_send(value) } if value.instance_of?(::Symbol)
                return proc { |enumerable| enumerable.public_send(value) } if value.instance_of?(::String)
                return value if value.instance_of?(::Proc)
                return proc { |enumerable| value.call(value) } if value.respond_to?(:call)
                return proc { |enumerable| enumerable } if value.nil?

                ::ConvenientService.raise Exceptions::InvalidEvaluateByValue.new(value: value)
              end

              ##
              # @param evaluate_by [String, Symbol, Proc]
              # @param result_block [Proc]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              # @internal
              #   NOTE: `catch` is used to support lazy enumerators, `chunk`, and `chunk_while`.
              #
              def with_propagated_result_returning(evaluate_by, &result_block)
                return propagated_result if propagated_result

                evaluate_by_block = cast_evaluate_by_block(evaluate_by)

                response =
                  catch(:propagated_result) do
                    object = evaluate_by_block.call(self.object)

                    ##
                    # TODO: Refactor.
                    #
                    modifiers.each { |modifier| modifier[:post_iterator_block].call } if evaluate_by.nil? || self.object.instance_of?(::Enumerator::Lazy)

                    {object: object}
                  end

                return response[:propagated_result] if response.has_key?(:propagated_result)

                yield(response[:object])
              end

              if Dependencies.ruby.version > 3.0
                ##
                # @param iterator_arguments [ConvenientService::Support::Arguments]
                # @param iterator_block [Proc]
                # @param with_processing_return_value_block [Proc]
                # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
                #
                def with_processing_return_value(iterator_arguments, iterator_block, &with_processing_return_value_block)
                  return yield(Support::UNDEFINED, propagated_result) if propagated_result

                  response =
                    catch(:propagated_result) do
                      object = iterator_block.call(*iterator_arguments.args, &step_aware_iteration_block_from(iterator_arguments.block))

                      ##
                      # TODO: Refactor.
                      #
                      modifiers.each { |modifier| modifier[:post_iterator_block].call } unless object.is_a?(::Enumerator)

                      {object: object}
                    end

                  return yield(Support::UNDEFINED, response[:propagated_result]) if response.has_key?(:propagated_result)

                  yield(response[:object], nil)
                end
              else
                ##
                # @param iterator_arguments [ConvenientService::Support::Arguments]
                # @param iterator_block [Proc]
                # @param with_processing_return_value_block [Proc]
                # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
                #
                def with_processing_return_value(iterator_arguments, iterator_block, &with_processing_return_value_block)
                  return yield(Support::UNDEFINED, propagated_result) if propagated_result

                  response =
                    catch(:propagated_result) do
                      object = iterator_block.call(*iterator_arguments.args, **iterator_arguments.kwargs, &step_aware_iteration_block_from(iterator_arguments.block))

                      ##
                      # TODO: Refactor.
                      #
                      modifiers.each { |modifier| modifier[:post_iterator_block].call } unless object.is_a?(::Enumerator)

                      {object: object}
                    end

                  return yield(Support::UNDEFINED, response[:propagated_result]) if response.has_key?(:propagated_result)

                  yield(response[:object], nil)
                end
              end

              ##
              # @param n [Integer]
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @param with_processing_return_value_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_exactly_return_value(n, iterator_arguments, iterator_block, &with_processing_return_value_block)
                return yield(Support::UNDEFINED, propagated_result) if propagated_result

                response =
                  catch(:propagated_result) do
                    step_aware_iteration_block = step_aware_iteration_block_from(iterator_arguments.block)

                    modifier = modifier_for(n, step_aware_iteration_block)

                    modifier[:pre_iterator_block].call

                    object = iterator_block.call(n, *iterator_arguments.args, &modifier[:iteration_block])

                    modifiers = self.modifiers.dup.push(modifier)

                    ##
                    # TODO: Refactor.
                    #
                    modifiers.each { |modifier| modifier[:post_iterator_block].call }.clear unless object.is_a?(::Enumerator)

                    {object: object, modifiers: modifiers}
                  end

                return yield(Support::UNDEFINED, response[:propagated_result]) if response.has_key?(:propagated_result)

                yield(response[:object], nil, response[:modifiers])
              end
            end
          end
        end
      end
    end
  end
end
