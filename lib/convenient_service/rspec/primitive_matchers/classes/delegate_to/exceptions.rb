# frozen_string_literal: true

module ConvenientService
  module RSpec
    module PrimitiveMatchers
      module Classes
        class DelegateTo
          module Exceptions
            class CallOriginalChainingIsAlreadySet < ::ConvenientService::Exception
              def initialize_without_arguments
                message = <<~TEXT
                  Call original chaining is already set.

                  Did you use `with_calling_original` or `without_calling_original` multiple times? Or a combination of them?
                TEXT

                initialize(message)
              end
            end

            class ArgumentsChainingIsAlreadySet < ::ConvenientService::Exception
              def initialize_without_arguments
                message = <<~TEXT
                  Arguments chaining is already set.

                  Did you use `with_arguments`, `with_any_arguments` or `without_arguments` multiple times? Or a combination of them?
                TEXT

                initialize(message)
              end
            end

            class ReturnValueChainingIsAlreadySet < ::ConvenientService::Exception
              def initialize_without_arguments
                message = <<~TEXT
                  Returns value chaining is already set.

                  Did you use `and_return_its_value` or `and_return { |delegation_value| ... }` multiple times? Or a combination of them?
                TEXT

                initialize(message)
              end
            end

            class ReturnCustomValueChainingInvalidArguments < ::ConvenientService::Exception
              def initialize_without_arguments
                message = <<~TEXT
                  Returns custom value chaining has invalid arguments.

                  Make sure you use one of the following forms:

                  `and_return(custom_value)`
                  `and_return { custom_value }`
                  `and_return { |delegation_value| process_somehow(delegation_value) }`
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
