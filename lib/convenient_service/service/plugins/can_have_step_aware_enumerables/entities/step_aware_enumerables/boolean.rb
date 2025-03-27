# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class Boolean < Entities::StepAwareEnumerables::Object
              ##
              # @api private
              #
              # @return [nil]
              #
              def default_data_key
                nil
              end

              ##
              # @api private
              #
              # @return [nil]
              #
              def default_evaluate_by
                nil
              end

              ##
              # @param data_key [Symbol, nil]
              # @param evaluate_by [String, Symbol, Proc]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: default_data_key, evaluate_by: default_evaluate_by)
                with_propagated_result_returning(evaluate_by) do |boolean|
                  boolean ? success : failure
                end
              end
            end
          end
        end
      end
    end
  end
end
