# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        module UsingActiveModelValidations
          class Middleware < MethodChainMiddleware
            intended_for :result, entity: :service

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def next(...)
              return result_from_active_model_validations if active_model_validations_errors.any?

              chain.next(...)
            end

            private

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def result_from_active_model_validations
              @result_from_active_model_validations ||= entity.public_send(
                status,
                data: active_model_validations_errors,
                message: active_model_validations_errors.first.to_a.map(&:to_s).join(" "),
                code: :unsatisfied_active_model_validations
              )
            end

            ##
            # @internal
            #   NOTE: errors method (from Active Model Validations) does NOT trigger validations
            #   that is why valid? is called here.
            #
            #   Check the following link for more info:
            #   - https://guides.rubyonrails.org/active_record_validations.html#validations-overview-errors
            #
            #   Quote (this method - errors):
            #   > This method is only useful after validations have been run, because it only inspects the errors collection and does not trigger validations itself.
            #
            def active_model_validations_errors
              @active_model_validations_errors ||= entity.tap(&:valid?).errors.messages.transform_values(&:first)
            end

            ##
            # @return [Symbol]
            #
            def status
              middleware_arguments.kwargs.fetch(:status) { :error }
            end
          end
        end
      end
    end
  end
end
