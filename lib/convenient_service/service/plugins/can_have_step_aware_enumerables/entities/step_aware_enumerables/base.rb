# frozen_string_literal: true

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
              # @return [void]
              #
              def initialize(object:, organizer:, propagated_result:)
                @object = object
                @organizer = organizer
                @propagated_result = propagated_result
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
                with_processing_return_value(iterator_arguments, exactly_enumerable_iterator_block_from(n, iterator_block)) { |value, propagated_result| step_aware_enumerable_from(value, propagated_result) }
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
                with_processing_return_value(iterator_arguments, exactly_enumerator_iterator_block_from(n, iterator_block)) { |value, propagated_result| step_aware_enumerator_from(value, propagated_result) }
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
                with_processing_return_value(iterator_arguments, exactly_lazy_enumerator_iterator_block_from(n, iterator_block)) { |value, propagated_result| step_aware_lazy_enumerator_from(value, propagated_result) }
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
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def step_aware_object_from(object, propagated_result)
                # TODO: Cast.
                Entities::StepAwareEnumerables::Object.new(object: object, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def step_aware_object_or_nil_from(object, propagated_result)
                Entities::StepAwareEnumerables::Object.new(object: object, organizer: organizer, propagated_result: propagated_result || (failure unless object))
              end

              ##
              # @param boolean [Boolean].
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def step_aware_boolean_from(boolean, propagated_result)
                Entities::StepAwareEnumerables::Boolean.new(object: boolean, organizer: organizer, propagated_result: propagated_result || (failure unless object))
              end

              ##
              # @param enumerable [Enumerable]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_enumerable_from(enumerable, propagated_result)
                Entities::StepAwareEnumerables::Enumerable.new(object: enumerable, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param array [Array]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_array_from(array, propagated_result)
                Entities::StepAwareEnumerables::Array.new(object: array, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param hash [Hash]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_hash_from(hash, propagated_result)
                Entities::StepAwareEnumerables::Hash.new(object: hash, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param set [Set]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def step_aware_set_from(set, propagated_result)
                Entities::StepAwareEnumerables::Set.new(object: set, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def step_aware_enumerator_from(enumerator, propagated_result)
                Entities::StepAwareEnumerables::Enumerator.new(object: enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param lazy_enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerator]
              #
              def step_aware_lazy_enumerator_from(lazy_enumerator, propagated_result)
                Entities::StepAwareEnumerables::LazyEnumerator.new(object: lazy_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param chain_enumerator [Enumerator::Chain]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ChainEnumerator]
              #
              def step_aware_chain_enumerator_from(chain_enumerator, propagated_result)
                Entities::StepAwareEnumerables::ChainEnumerator.new(object: chain_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param arithmetic_sequence_enumerator [Enumerator::ArithmeticSequence]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::ArithmeticSequence::Enumerator]
              #
              def step_aware_arithmetic_sequence_enumerator_from(arithmetic_sequence_enumerator, propagated_result)
                Entities::StepAwareEnumerables::ArithmeticSequenceEnumerator.new(object: arithmetic_sequence_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param n [Integer]
              # @param iterator_block [Proc, nil]
              # @return [Proc]
              #
              def exactly_enumerable_iterator_block_from(n, iterator_block)
                proc do |*args, &step_aware_iteration_block|
                  throw :propagated_result, {propagated_result: error} if n < 0

                  iterator_details = {match_count: 0}

                  counter_aware_iteration_block =
                    if step_aware_iteration_block
                      proc do |*args|
                        value = step_aware_iteration_block.call(*args)

                        iterator_details[:match_count] += 1 if value

                        throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] > n

                        value
                      end
                    end

                  values = iterator_block.call(*args, &counter_aware_iteration_block)

                  throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] != n

                  values
                end
              end

              ##
              # @param n [Integer]
              # @param iterator_block [Proc, nil]
              # @return [Proc]
              #
              def exactly_enumerator_iterator_block_from(n, iterator_block)
                proc do |*args, &step_aware_iteration_block|
                  ::Enumerator.new do |yielder|
                    throw :propagated_result, {propagated_result: error} if n < 0

                    original_enumerator = iterator_block.call(*args, &step_aware_iteration_block).each

                    iterator_details = {match_count: 0}

                    loop do
                      value = original_enumerator.next

                      iterator_details[:match_count] += 1 if value

                      throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] > n

                      yielder.yield(value)
                    end

                    throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] != n

                    original_enumerator
                  end
                end
              end

              ##
              # @param n [Integer]
              # @param iterator_block [Proc, nil]
              # @return [Proc]
              #
              def exactly_lazy_enumerator_iterator_block_from(n, iterator_block)
                proc do |*args, &step_aware_iteration_block|
                  enumerator =
                    ::Enumerator.new do |yielder|
                      throw :propagated_result, {propagated_result: error} if n < 0

                      original_enumerator = iterator_block.call(*args, &step_aware_iteration_block).each

                      iterator_details = {match_count: 0}

                      loop do
                        ##
                        # HACK: For some reason `catch(:propagated_result) { throw :propagated_result, {propagated_result: ...} }` does NOT work for the following test.
                        #
                        #   # Place `byebug` before `catch` in `with_propagated_result_returning` and `with_processing_return_value` to see this issue in practice.
                        #   expect(service.step_aware_enumerator(lazy_enumerator([:success, :error, :exception])).select_exactly(1) { |status| step status_service, in: [status: -> { status }] }.result).to be_error.without_data
                        #
                        # - https://ruby-doc.org/core-2.7.0/UncaughtThrowError.html
                        # - https://ruby-doc.org/core-2.7.0/Kernel.html#method-i-catch
                        #
                        # NOTE: Probably the reason of issue is `Enumerator::Generator`.
                        # - https://ruby-doc.org/core-2.7.0/Enumerator/Generator.html
                        #
                        response =
                          begin
                            {value: original_enumerator.next}
                          rescue UncaughtThrowError => e
                            e.value
                          end

                        throw :propagated_result, {propagated_result: response[:propagated_result]} if response.has_key?(:propagated_result)

                        iterator_details[:match_count] += 1 if response[:value]

                        throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] > n

                        yielder.yield(response[:value])
                      end

                      throw :propagated_result, {propagated_result: failure} if iterator_details[:match_count] != n

                      original_enumerator
                    end

                  enumerator.lazy
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

                response = catch(:propagated_result) { {object: evaluate_by_block.call(object)} }

                return response[:propagated_result] if response.has_key?(:propagated_result)

                yield(response[:object])
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @param with_processing_return_value_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Object]
              #
              def with_processing_return_value(iterator_arguments, iterator_block, &with_processing_return_value_block)
                return yield(Support::UNDEFINED, propagated_result) if propagated_result

                response = catch(:propagated_result) { {object: iterator_block.call(*iterator_arguments.args, &step_aware_iteration_block_from(iterator_arguments.block))} }

                return yield(Support::UNDEFINED, response[:propagated_result]) if response.has_key?(:propagated_result)

                yield(response[:object], nil)
              end
            end
          end
        end
      end
    end
  end
end
