# frozen_string_literal: true

require_relative "abstract_method/exceptions"

module ConvenientService
  module Support
    module AbstractMethod
      include Support::Concern

      class_methods do
        def abstract_method(*names)
          names.each do |name|
            define_method(name) do |*args, **kwargs, &block|
              raise Exceptions::AbstractMethodNotOverridden.new(instance: self, method: name)
            end
          end
        end
      end
    end
  end
end
