# frozen_string_literal: true

module ConvenientService
  module Factories
    module Services
      ##
      # @return [Class]
      #
      def create_service(...)
        create_service_class(...)
      end

      ##
      # @param steps [<Class, Symbol>]
      # @return [Class]
      #
      def create_service_class(steps: [])
        ::Class.new.tap do |klass|
          klass.class_exec(steps: steps) do
            include ::ConvenientService::Configs::Standard

            steps.each do |step_name|
              case step_name
              when ::Class
                step step_name
              when ::Symbol
                step step_name

                define_method(step_name) { success }
              end
            end

            def result
              success
            end
          end
        end
      end
    end
  end
end
