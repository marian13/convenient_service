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
              attr_reader :propagated_result

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
              # @internal
              #   NOTE: Uncomment and place the following code snippet after the `initialize` method to debug whether original classes and step aware wrappers are properly mapped.
              #   TODO: Consider to create an assertion or to introduce logs.
              #
              #     def initialize(object:, organizer:, propagated_result:)
              #       if object.is_a?(::Enumerator)
              #         mapping = {
              #           ::Enumerator => Entities::ServiceAwareEnumerables::Enumerator,
              #           ::Enumerator::Lazy => Entities::ServiceAwareEnumerables::LazyEnumerator,
              #           ::Enumerator::Chain => Entities::ServiceAwareEnumerables::ChainEnumerator,
              #            ::Enumerator::ArithmeticSequence => Entities::ServiceAwareEnumerables::ArithmeticSequenceEnumerator
              #         }
              #
              #         raise "No mapping for class `#{object.class}`." unless mapping[object.class]
              #
              #         if !self.instance_of?(mapping[object.class])
              #           p [object.class, self.class]
              #
              #           raise "Mapping Mismatch - `#{object.class}` and `#{self.class}` are NOT sychronized."
              #         end
              #       end
              #
              #       @object = object
              #       @organizer = organizer
              #       @propagated_result = propagated_result
              #     end
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_object(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_object_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_object_or_nil(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_object_or_nil_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_boolean(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_boolean_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_enumerable(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_enumerable_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_array(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_array_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_hash(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_hash_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def with_processing_return_value_as_set(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_set_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def with_processing_return_value_as_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_enumerator_from(value, propagated_result) }
              end

              ##
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              alias_method :with_processing_return_value_as_enumerator_generator, :with_processing_return_value_as_enumerator

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::LazyEnumerator]
              #
              def with_processing_return_value_as_lazy_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_lazy_enumerator_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def with_processing_return_value_as_chain_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(iterator_arguments, iterator_block) { |value, propagated_result| service_aware_chain_enumerator_from(value, propagated_result) }
              end

              ##
              # @param iterator_arguments [ConvenientService::Support::Arguments]
              # @param iterator_block [Proc]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ArithmeticSequenceEnumerator]
              #
              def with_processing_return_value_as_arithmetic_sequence_enumerator(iterator_arguments = Support::Arguments.null_arguments, &iterator_block)
                with_processing_return_value(arguments, iterator_block) { |value, propagated_result| service_aware_arithmetic_sequence_enumerator_from(value, propagated_result) }
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [Proc]
              #
              # @internal
              #   NOTE: It may look very appealing to return data objects instead of hashes. For example:
              #     # With hashes.
              #     result =
              #       service_aware_enumerable(users)
              #         .map { |user| step ProcessUser, in: :user, out: [:attributes, :associations] }
              #         .each { |values| p [values[:attributes], values[:associations]] }
              #         .result(data_key: :items)
              #
              #     result.data[:items]
              #     # => [{attributes: {}, associations: []}, {attributes: {}, associations: []}]
              #
              #     # With data objects.
              #     result =
              #       service_aware_enumerable(users)
              #         .map { |user| step ProcessUser, in: :user, out: [:attributes, :associations] }
              #         .each { |data| p [data.attributes, data.associations] }
              #         .result(data_key: :items)
              #
              #     result.data[:items]
              #     # => [<...Data attributes: {}, associations: []>, <...Data attributes: {}, associations: []>]
              #
              #     But:
              #     - Is it OK to return nested data objects from results?
              #     - If not, how can those nested data objects be efficiently converted into hashes only for the results (data may return arrays, hashes, sets, enumerators, arithmetic sequences, etc.)?
              #
              #     next data.one? ? data.values.first : result.create_data(data)
              #
              def service_aware_iteration_block_from(iteration_block)
                return unless iteration_block

                proc do |*args|
                  service = iteration_block.call(*args)

                  service.to_service_aware_iteration_block_value
                end
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def service_aware_object_from(object, propagated_result)
                # TODO: Cast.
                Entities::ServiceAwareEnumerables::Object.new(object: object, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param object [Object] Can be any type.
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def service_aware_object_or_nil_from(object, propagated_result)
                Entities::ServiceAwareEnumerables::ObjectOrNil.new(object: object, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param boolean [Boolean].
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              def service_aware_boolean_from(boolean, propagated_result)
                Entities::ServiceAwareEnumerables::Boolean.new(object: boolean, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param enumerable [Enumerable]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
              #
              def service_aware_enumerable_from(enumerable, propagated_result)
                Entities::ServiceAwareEnumerables::Enumerable.new(object: enumerable, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param array [Array]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
              #
              def service_aware_array_from(array, propagated_result)
                Entities::ServiceAwareEnumerables::Array.new(object: array, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param hash [Hash]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
              #
              def service_aware_hash_from(hash, propagated_result)
                Entities::ServiceAwareEnumerables::Hash.new(object: hash, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param set [Set]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerable]
              #
              def service_aware_set_from(set, propagated_result)
                Entities::ServiceAwareEnumerables::Set.new(object: set, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def service_aware_enumerator_from(enumerator, propagated_result)
                Entities::ServiceAwareEnumerables::Enumerator.new(object: enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param lazy_enumerator [Enumerator]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Enumerator]
              #
              def service_aware_lazy_enumerator_from(lazy_enumerator, propagated_result)
                Entities::ServiceAwareEnumerables::LazyEnumerator.new(object: lazy_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param chain_enumerator [Enumerator::Chain]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ChainEnumerator]
              #
              def service_aware_chain_enumerator_from(chain_enumerator, propagated_result)
                Entities::ServiceAwareEnumerables::ChainEnumerator.new(object: chain_enumerator, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param arithmetic_sequence_enumerator [Enumerator::ArithmeticSequence]
              # @param propagated_result [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::ArithmeticSequence::Enumerator]
              #
              def service_aware_arithmetic_sequence_enumerator_from(arithmetic_sequence_enumerator, propagated_result)
                Entities::ServiceAwareEnumerables::ArithmeticSequenceEnumerator.new(object: arithmetic_sequence_enumerator, organizer: organizer, propagated_result: propagated_result)
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
              # @return [ConvenientService::Support::Arguments]
              #
              def arguments(...)
                Support::Arguments.new(...)
              end

              ##
              # @param object [Object] Can be any type.
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Base]
              #
              def cast_service_aware_enumerable(object)
                Commands::CastServiceAwareEnumerable.call(object: object, organizer: organizer, propagated_result: propagated_result)
              end

              ##
              # @param value [Symbol, String, Proc, nil]
              # @return [Proc]
              # @raise [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Exceptions::InvalidEvaluateByValue]
              #
              def cast_evaluate_by_block(value)
                return proc { |enumerable| enumerable.public_send(value) } if value.instance_of?(::Symbol)
                return proc { |enumerable| enumerable.public_send(value) } if value.instance_of?(::String)
                return value if value.instance_of?(::Proc)
                return proc { |enumerable| value.call(enumerable) } if value.respond_to?(:call)
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
              # @return [ConvenientService::Service::Plugins::CanHaveServiceAwareEnumerables::Entities::ServiceAwareEnumerables::Object]
              #
              # @internal
              #   NOTE: `catch` is used to support lazy enumerators, `chunk`, and `chunk_while`.
              #
              def with_processing_return_value(iterator_arguments, iterator_block, &with_processing_return_value_block)
                return yield(Support::UNDEFINED, propagated_result) if propagated_result

                response = catch(:propagated_result) { {object: iterator_block.call(*iterator_arguments.args, **iterator_arguments.kwargs, &iterator_arguments.block)} }

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
