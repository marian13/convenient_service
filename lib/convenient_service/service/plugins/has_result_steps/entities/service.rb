# frozen_string_literal: true

require_relative "service/class_methods"

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          ##
          # NOTE: Service is a wrapper for a service class (klass). For example:
          #
          #   step SomeService, in: :foo, out: :bar
          #   # klass is `SomeService` in this particular case.
          #
          class Service
            include Support::Castable
            include Support::Delegate

            extend ClassMethods

            delegate :result, :step_class, to: :klass

            attr_reader :klass

            def initialize(klass)
              @klass = klass
            end

            def has_defined_method?(method)
              Utils::Method.defined?(method, in: klass)
            end

            def ==(other)
              casted = cast(other)

              return unless casted

              return false if klass != casted.klass

              true
            end

            ##
            # TODO: Unify `inspect`. Specs for `inspect`.
            #
            def inspect
              "HasResultSteps::Service(#{klass})"
            end
          end
        end
      end
    end
  end
end
