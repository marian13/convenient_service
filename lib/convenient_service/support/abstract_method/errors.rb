# frozen_string_literal: true

module ConvenientService
  module Support
    module AbstractMethod
      module Errors
        class AbstractMethodNotOverridden < ::ConvenientService::Error
          def initialize(instance:, method:)
            klass = instance.is_a?(::Class) ? instance : instance.class
            method_type = Utils::Object.resolve_type(instance)

            message = <<~TEXT
              `#{klass}` should implement abstract #{method_type} method `#{method}`.
            TEXT

            super(message)
          end
        end
      end
    end
  end
end
