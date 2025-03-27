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
