# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        module UsingDryValidation
          class Middleware < MethodChainMiddleware
            intended_for :result, entity: :service

            def next(...)
              return entity.failure(data: errors, message: errors.first.to_a.map(&:to_s).join(" ")) if errors.any?

              chain.next(...)
            end

            private

            ##
            # NOTE: An example of `Dry::Validation::Contract` usage.
            # https://dry-rb.org/gems/dry-validation/1.8/#quick-start
            #
            # TODO: Return one or all errors?
            #
            def errors
              @errors ||= resolve_errors
            end

            def constructor_kwargs
              @constructor_kwargs ||= entity.constructor_arguments.kwargs
            end

            def contract
              @contract ||= entity.class.contract
            end

            def resolve_errors
              return {} unless contract.schema

              contract.new
                .call(constructor_kwargs)
                .errors
                .to_h
                .transform_values(&:first)
            end
          end
        end
      end
    end
  end
end
