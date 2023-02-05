# frozen_string_literal: true

module ConvenientService
  module Factories
    module Steps
      ##
      # @example Default.
      #
      #   class Step
      #     include ConvenienService::Standard::Config
      #   end
      #
      #   class Service
      #     include ConvenienService::Standard::Config
      #     # ...
      #     step Step # `step` is `args.first`
      #     # ...
      #   end
      #
      def create_step(...)
        create_service_step_class(...)
      end

      ##
      # @example Default.
      #
      #   class Service
      #     include ConvenienService::Standard::Config
      #     # ...
      #     step 42 # `step` is `args.first`
      #     # ...
      #   end
      #
      def create_invalid_step(...)
        42
      end

      ##
      # @example Default.
      #
      #   class Step
      #     include ConvenienService::Standard::Config
      #   end
      #
      #   class Service
      #     include ConvenienService::Standard::Config
      #     # ...
      #     step Step # `step` is `args.first`
      #     # ...
      #   end
      #
      def create_service_step(...)
        create_service_step_class(...)
      end

      ##
      # @example Default.
      #
      #   class Step
      #     include ConvenienService::Standard::Config
      #   end
      #
      #   class Service
      #     include ConvenienService::Standard::Config
      #     # ...
      #     step :validate # `step` is `args.first`
      #     # ...
      #   end
      #
      def create_method_step
        ::Faker::Verb.unique.base.to_sym
      end

      ##
      # @example Default.
      #
      #   class Step
      #     include ConvenienService::Standard::Config
      #   end
      #
      #   class Service
      #     include ConvenienService::Standard::Config
      #     # ...
      #     step :result # `step` is `args.first`
      #     # ...
      #   end
      #
      def create_result_method_step
        :result
      end

      ##
      # @example Default.
      #
      #   class Step
      #     include ConvenienService::Standard::Config
      #   end
      #
      #   class Service
      #     include ConvenienService::Standard::Config
      #     # ...
      #     step Step # `step` is `args.first`
      #     # ...
      #   end
      #
      def create_service_step_class
        create_service_class
      end
    end
  end
end
