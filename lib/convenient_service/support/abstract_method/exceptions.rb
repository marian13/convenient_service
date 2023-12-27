# frozen_string_literal: true

module ConvenientService
  module Support
    module AbstractMethod
      module Exceptions
        class AbstractMethodNotOverridden < ::ConvenientService::Exception
          def initialize_with_kwargs(instance:, method:)
            klass = instance.is_a?(::Class) ? instance : instance.class
            method_type = Utils::Object.resolve_type(instance)

            message = <<~TEXT
              `#{klass}` should implement abstract #{method_type} method `#{method}`.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
