# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultParamsValidations
        module UsingActiveModelValidations
          class Middleware < MethodChainMiddleware
            def next(...)
              return entity.failure(data: errors) if errors.any?

              chain.next(...)
            end

            private

            ##
            # NOTE: errors method (from Active Model Validations) does NOT trigger validations
            # that is why valid? is called here.
            #
            # Check the following link for more info:
            # https://guides.rubyonrails.org/active_record_validations.html#validations-overview-errors
            #
            # Quote (this method - errors):
            # > This method is only useful after validations have been run, because it only inspects the errors collection and does not trigger validations itself.
            #
            def errors
              @errors ||= entity.tap(&:valid?).errors.messages.transform_values(&:first)
            end
          end
        end
      end
    end
  end
end
