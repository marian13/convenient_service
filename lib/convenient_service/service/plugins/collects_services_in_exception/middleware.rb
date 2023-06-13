# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CollectsServicesInException
        class Middleware < MethodChainMiddleware
          intended_for [
            :initialize,
            :result,
            :try_result
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
            exception.instance_exec(entity) { |entity| define_singleton_method(:services) { @services ||= [] } } unless exception.respond_to?(:services)

            Utils::Array.limited_push(exception.services, entity, limit: max_services_size)

            raise
          end

          private

          ##
          # @return [Integer]
          #
          def max_services_size
            arguments.kwargs.fetch(:max_services_size) { Constants::DEFAULT_MAX_SERVICES_SIZE }
          end
        end
      end
    end
  end
end
