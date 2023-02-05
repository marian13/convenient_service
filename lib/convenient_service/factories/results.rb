# frozen_string_literal: true

module ConvenientService
  module Factories
    module Results
      ##
      # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
      #
      # @example Default.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success # `result` is return value
      #     end
      #   end
      #
      def create_result
        service_class = create_service_class

        service_class.result
      end

      ##
      # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
      #
      # @example Default.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success # `result` is return value
      #     end
      #   end
      #
      def create_result_without_step
        service_class = create_service_class

        service_class.result
      end

      ##
      # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
      #
      # @example Default.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     step Step # `result` is return value
      #   end
      #
      def create_result_with_step(...)
        create_result_with_service_step(...)
      end

      ##
      # @param service_step [Class]
      # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
      #
      # @example Default.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     step Step # `result` is return value
      #   end
      #
      # @example When `service_step` is passed.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     step service_step # `result` is return value
      #   end
      #
      def create_result_with_service_step(service_step: Support::NOT_PASSED)
        service_step_class = (service_step == Support::NOT_PASSED) ? create_service_step_class : service_step

        service_class = create_service_class(steps: [service_step_class])

        service_class.result
      end

      ##
      # @param method_step [Symbol]
      # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
      #
      # @example Default.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     step :validate # `result` is return value
      #   end
      #
      # @example When `method_step` is passed.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     step method_step # `result` is return value
      #   end
      #
      def create_result_with_method_step(method_step: Support::NOT_PASSED)
        method_step = (method_step == Support::NOT_PASSED) ? create_method_step : method_step

        service_class = create_service_class(steps: [method_step])

        service_class.result
      end

      ##
      # @return [ConvenientService::Service::Plugins::HasResult::Entities::Result]
      #
      # @example Default.
      #
      #   class Service
      #     include ConvenientService::Standard::Config
      #
      #     step :result # `result` is return value
      #   end
      #
      def create_result_with_result_method_step
        service_class = create_service_class(steps: [:result])

        service_class.result
      end
    end
  end
end
