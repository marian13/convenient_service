# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasJSendResultParamsValidations
        ##
        # @internal
        #   TODO: Consider to add versioning, since `dry` gems often modify thier public API.
        #
        module UsingDryValidation
          class Middleware < MethodChainMiddleware
            intended_for :result, entity: :service

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def next(...)
              return result_from_dry_validation if dry_validation_errors.any?

              chain.next(...)
            end

            private

            ##
            # @return [ConvenientService::Service::Plugins::HasJSendResult::Entities::Result]
            #
            def result_from_dry_validation
              entity.public_send(
                status,
                data: dry_validation_errors,
                message: dry_validation_errors.first.to_a.map(&:to_s).join(" "),
                code: :unsatisfied_dry_validation
              )
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            # @internal
            #   NOTE: An example of `Dry::Validation::Contract` usage.
            #   https://dry-rb.org/gems/dry-validation/1.8/#quick-start
            #
            #   TODO: Return one or all errors?
            #
            def dry_validation_errors
              @dry_validation_errors ||= resolve_dry_validation_errors
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def constructor_kwargs
              @constructor_kwargs ||= entity.constructor_arguments.kwargs
            end

            ##
            # @return [Dry::Validation::Contract]
            #
            def contract
              @contract ||= entity.class.contract
            end

            ##
            # @return [Symbol]
            #
            def status
              middleware_arguments.kwargs.fetch(:status) { :error }
            end

            ##
            # @return [Hash{Symbol => Object}]
            #
            def resolve_dry_validation_errors
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
