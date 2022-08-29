# frozen_string_literal: true

module ConvenientService
  module Utils
    module Method
      class Defined < Support::Command
        attr_reader :method, :klass

        def initialize(method, **kwargs)
          @method = method.to_s
          @klass = kwargs.fetch(:in)
        end

        def call
          klass.method_defined?(method) || klass.private_method_defined?(method)
        end
      end
    end
  end
end
