# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultParamsValidations
        module UsingDryValidation
          class Middleware < Core::MethodChainMiddleware
            def next(...)
              return entity.failure(data: errors) if errors.any?

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
              @errors ||=
                entity
                  .class
                  .contract
                  .new
                  .call(**entity.constructor_params.kwargs)
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
