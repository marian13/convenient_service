# frozen_string_literal: true

module ConvenientService
  module Common
    module Plugins
      module SetsDisplayValue
        class Middleware < Core::MethodChainMiddleware
          def next(*args, **kwargs, &block)
            return chain.next(*args, **kwargs, &block) unless kwargs.has_key?(:display)

            entity.instance_variable_set(:@display, true) if kwargs[:display] == true

            kwargs.delete(:display)

            chain.next(*args, **kwargs, &block)
          end
        end
      end
    end
  end
end
