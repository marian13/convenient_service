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
            class ArithmeticSequenceEnumerator < Entities::StepAwareEnumerables::Enumerator
              ##
              # @api private
              #
              # @return [Enumerator::ArithmeticSequence]
              #
              alias_method :arithmetic_sequence_enumerator, :object

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
                nil
              end

              ##
              # @param iteration_block [Proc, nil]
              # @return [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Entities::StepAwareEnumerables::Enumerable]
              #
              def each(&iteration_block)
                with_processing_return_value_as_arithmetic_sequence_enumerator(arguments(&iteration_block)) do |&step_aware_iteration_block|
                  enumerable.each(&step_aware_iteration_block)
                end
              end
            end
          end
        end
      end
    end
  end
end
