# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CollectsServicesInException
        class Middleware < MethodChainMiddleware
          intended_for [
            :initialize,
            :result,
            :fallback_result
          ],
            entity: :service

          ##
          # @raise [StandardError]
          #
          # @internal
          #   NOTE: `rescue ::StandardError => exception` is the same as `rescue => exception`.
          #
          def next(...)
            chain.next(...)
          rescue => exception
            exception.instance_exec { define_singleton_method(:services) { @services ||= [] } } unless exception.respond_to?(:services)

            Utils::Array.limited_push(exception.services, service_details, limit: max_services_size)

            raise
          end

          private

          ##
          # @return [Hash{Symbol => Object}]
          #
          def service_details
            Commands::ExtractServiceDetails.call(service: entity, method: method)
          end

          ##
          # @return [Integer]
          #
          def max_services_size
            middleware_arguments.kwargs.fetch(:max_services_size) { Constants::DEFAULT_MAX_SERVICES_SIZE }
          end
        end
      end
    end
  end
end
