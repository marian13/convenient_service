# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveStepAwareEnumerables
        module Entities
          module StepAwareEnumerables
            class Object < Entities::StepAwareEnumerables::Base
              ##
              # @return [Symbol]
              #
              def default_data_key
                :value
              end

              ##
              # @return [nil]
              #
              def default_evaluate_by
                nil
              end

              private

              ##
              # @param method_name [Symbol, String]
              # @param include_private [Boolean]
              # @return [Boolean]
              #
              # @internal
              #   TODO: Actual behaviour.
              #
              def respond_to_missing?(method_name, include_private = false)
                false
              end

              ##
              # @raise [ConvenientService::Service::Plugins::CanHaveStepAwareEnumerables::Exceptions::AlreadyUsedTerminalChaining]
              #
              def method_missing(method, *args, **kwargs, &block)
                ::ConvenientService.raise Exceptions::AlreadyUsedTerminalChaining.new
              end
            end
          end
        end
      end
    end
  end
end
