# frozen_string_literal: true

module ConvenientService
  module Support
    module AbstractMethod
      include Support::Concern

      included do
        extend ClassMethods
      end

      module Errors
        class AbstractMethodNotOverridden < ::StandardError
          def initialize(instance:, method:)
            klass = instance.is_a?(::Class) ? instance : instance.class
            method_type = Utils::Object.resolve_type(instance)

            message = <<~TEXT
              `#{klass}' should implement abstract #{method_type} method `#{method}'.
            TEXT

            super(message)
          end
        end
      end

      module ClassMethods
        def abstract_method(*names)
          names.each do |name|
            define_method(name) do |*args, **kwargs, &block|
              raise Errors::AbstractMethodNotOverridden.new(instance: self, method: name)
            end
          end
        end
      end
    end
  end
end
