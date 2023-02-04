# frozen_string_literal: true

module ConvenientService
  module Factories
    module Steps
      def create_step(...)
        create_service_step_class(...)
      end

      def create_service_step(...)
        create_service_step_class(...)
      end

      def create_method_step
        ::Faker::Verb.unique.base.to_sym
      end

      def create_result_method_step
        :result
      end

      def create_service_step_class
        create_service_class
      end
    end
  end
end
