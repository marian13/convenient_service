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
            class ObjectOrNil < Entities::StepAwareEnumerables::Object
              ##
              # @api private
              #
              # @return [Object, nil]
              #
              alias_method :object_or_nil, :object

              ##
              # @param data_key [Symbol, nil]
              # @param evaluate_by [String, Symbol, Proc]
              # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
              #
              def result(data_key: default_data_key, evaluate_by: default_evaluate_by)
                with_propagated_result_returning(evaluate_by) do |object_or_nil|
                  object_or_nil ? success(data_key => object_or_nil) : failure
                end
              end
            end
          end
        end
      end
    end
  end
end
