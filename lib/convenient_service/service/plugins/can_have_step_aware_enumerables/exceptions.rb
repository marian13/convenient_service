# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Exceptions
          class ObjectIsNotEnumerable < ::ConvenientService::Exception
            ##
            # @param object [Object] Can be any type.
            # @return [void]
            #
            def initialize_with_kwargs(object:)
              message = <<~TEXT
                Object of class `#{Utils::Class.display_name(object.class)}` is NOT enumerable.

                Valid enumerable examples are classes that mix in `Enumerable` module like `Array`, `Hash`, `Set`, `Range`, `IO`, `Enumerator`, etc.
              TEXT

              initialize(message)
            end
          end

          class ObjectIsNotEnumerator < ::ConvenientService::Exception
            ##
            # @param object [Object] Can be any type.
            # @return [void]
            #
            def initialize_with_kwargs(object:)
              message = <<~TEXT
                Object of class `#{Utils::Class.display_name(object.class)}` is NOT enumerator.

                Valid enumerator examples are `Enumerator`, `Enumerator::Lazy`, `Enumerator::Chain`, `Enumerator::ArithmeticSequence`, etc.

                Maybe you mistyped `step_aware_enumerator` instead of `step_aware_enumerable`?
              TEXT

              initialize(message)
            end
          end

          class AlreadyUsedTerminalChaining < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_without_arguments
              message = <<~TEXT
                Step aware enumerable has already used a terminal chaining like `all?`, `any?`, `find`, `first`, etc.
              TEXT

              initialize(message)
            end
          end

          class InvalidEvaluateByValue < ::ConvenientService::Exception
            ##
            # @param value [Object] Can be any type.
            # @return [void]
            #
            def initialize_with_kwargs(value:)
              message = <<~TEXT
                `evaluate_by` value `#{value}` is NOT supported.

                Here are some examples of valid values:
                  # `Symbol` value.
                  .result(evaluate_by: :to_a)

                  # `String` value.
                  .result(evaluate_by: "to_h")

                  # `Proc` value.
                  .result(evaluate_by: ->(enumerable) { enumerable.to_set })

                  # Object that respond to `call`.
                  class Evaluator
                    def self.call(enumerable)
                      enumerable.to_s
                    end
                  end

                  .result(evaluate_by: Evaluator)

                  # Pass `nil` to skip evaluation (NOT recommended for enumerators).
                  .result(evaluate_by: nil)
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
