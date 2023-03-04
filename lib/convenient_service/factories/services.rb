# frozen_string_literal: true

##
# WIP: Factory API is NOT well-thought yet. It will be revisited and completely refactored at any time.
#
module ConvenientService
  module Factories
    module Services
      ##
      # @return [Class]
      #
      # @example Default.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success
      #     end
      #   end
      #
      def create_service_with_success_result
        ::Class.new do
          include ::ConvenientService::Configs::Standard

          ##
          # IMPORTANT:
          #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
          #   - It will be reenabled after the introduction of thread-safety specs.
          #   - Do not use it in production yet.
          #
          middlewares :step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          def result
            success
          end
        end
      end

      ##
      # @return [Class]
      #
      # @example Default.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       error("foo")
      #     end
      #   end
      #
      def create_service_with_not_success_result
        create_service_with_error_result
      end

      ##
      # @return [Class]
      #
      # @example Default.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       failure(foo: "bar")
      #     end
      #   end
      #
      def create_service_with_failure_result
        ::Class.new do
          include ::ConvenientService::Configs::Standard

          ##
          # IMPORTANT:
          #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
          #   - It will be reenabled after the introduction of thread-safety specs.
          #   - Do not use it in production yet.
          #
          middlewares :step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          def result
            failure(data)
          end

          private

          def data
            @data ||= {::Faker::Lorem.word => ::Faker::Lorem.sentence}
          end
        end
      end

      ##
      # @return [Class]
      #
      # @example Default.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       error("foo")
      #     end
      #   end
      #
      def create_service_with_error_result
        ::Class.new do
          include ::ConvenientService::Configs::Standard

          ##
          # IMPORTANT:
          #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
          #   - It will be reenabled after the introduction of thread-safety specs.
          #   - Do not use it in production yet.
          #
          middlewares :step, scope: :class do
            use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
          end

          def result
            error(message)
          end

          private

          def message
            @message ||= ::Faker::Lorem.sentence
          end
        end
      end

      ##
      # @return [Class]
      #
      # @example Default.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success
      #     end
      #   end
      #
      def create_service(...)
        create_service_class(...)
      end

      ##
      # @param steps [<Class, Symbol>]
      # @return [Class]
      #
      # @example Default.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     def result
      #       success
      #     end
      #   end
      #
      # @example One step.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     step Step # `steps.first` is `args.first`.
      #   end
      #
      # @example One method step.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     step :validate # `steps.first` is `args.first`.
      #
      #     def validate
      #       success
      #     end
      #   end
      #
      # @example Multiple steps.
      #   class Service # `service` is class.
      #     include ConvenientService::Standard::Config
      #
      #     step Step # `steps[0]` is `args.first`.
      #     step OtherStep # `steps[1]` is `args.first`.
      #     step :result # `steps[2]` is `args.first`.
      #
      #     def result
      #       success
      #     end
      #   end
      #
      def create_service_class(steps: [])
        ::Class.new.tap do |klass|
          klass.class_exec(steps: steps) do
            include ::ConvenientService::Configs::Standard

            ##
            # IMPORTANT:
            #   - `CanHaveMethodSteps` is disabled in the Standard config since it causes race conditions in combination with `CanHaveStubbedResult`.
            #   - It will be reenabled after the introduction of thread-safety specs.
            #   - Do not use it in production yet.
            #
            middlewares :step, scope: :class do
              use ConvenientService::Plugins::Service::CanHaveMethodSteps::Middleware
            end

            steps.each do |step_name|
              case step_name
              when ::Class
                step step_name
              when ::Symbol
                step step_name

                define_method(step_name) { success }
              end
            end

            if steps.none?
              def result
                success
              end
            end
          end
        end
      end
    end
  end
end
