# frozen_string_literal: true

##
# WIP: Factory API is NOT well-thought yet. It will be revisited and completely refactored at any time.
#
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

      ##
      # @return [Hash]
      #
      # @example Default.
      #
      #   {
      #     service: result.service,
      #     status: :success,
      #     data: {foo: :bar},
      #     message: "",
      #     code: :default_success
      #   }
      #
      def create_result_attributes
        create_result.jsend_attributes.to_h
      end

      ##
      # @return [Hash]
      #
      # @example Default.
      #
      #   {
      #     service: result.service,
      #     status: :success,
      #     data: {foo: :bar},
      #     message: "",
      #     code: :default_success,
      #     parent: result.parent
      #   }
      #
      def create_result_attributes_with_parent(parent: Support::NOT_PASSED)
        parent = (parent == Support::NOT_PASSED) ? create_result_parent : parent

        result_attributes = create_result_attributes

        result_attributes.merge(parent: parent)
      end

      ##
      # @return [Hash]
      #
      # @example Default.
      #
      #   {
      #     service: result.service,
      #     status: :success,
      #     data: {foo: :bar},
      #     message: "",
      #     code: :default_success,
      #     step: result.step
      #   }
      #
      def create_result_attributes_with_step(step: Support::NOT_PASSED)
        step = (step == Support::NOT_PASSED) ? create_result_step : step

        result_attributes = create_result_attributes

        result_attributes.merge(step: step)
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
      #       success # `result_parent` is return value
      #     end
      #   end
      #
      def create_result_parent
        create_result
      end
    end
  end
end
