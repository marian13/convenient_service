# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module CanBeResultStep
                module CanBeExecuted
                  module Errors
                    class MethodForStepIsNotDefined < ::ConvenientService::Exception
                      ##
                      # @param service_class [Class]
                      # @param method_name [Symbol]
                      # @return [void]
                      #
                      def initialize(service_class:, method_name:)
                        message = <<~TEXT
                          Service `#{service_class}` tries to use `:#{method_name}` method in a step, but it is NOT defined.

                          Did you forget to define it?
                        TEXT

                        super(message)
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
