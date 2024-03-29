# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeMethodStep
                module CanBeExecuted
                  module Exceptions
                    class MethodForStepIsNotDefined < ::ConvenientService::Exception
                      ##
                      # @param service_class [Class]
                      # @param method_name [Symbol]
                      # @return [void]
                      #
                      def initialize_with_kwargs(service_class:, method_name:)
                        message = <<~TEXT
                          Service `#{service_class}` tries to use `:#{method_name}` method in a step, but it is NOT defined.

                          Did you forget to define it?
                        TEXT

                        initialize(message)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
