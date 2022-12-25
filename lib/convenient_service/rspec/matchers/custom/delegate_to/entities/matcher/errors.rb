# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        class DelegateTo
          module Entities
            class Matcher
              module Errors
                class FailedToSetExpectedArguments < ConvenientService::Error
                  def initialize(arguments:)
                    message = <<~TEXT
                      Faileds to set `#{arguments}` by `#expected_arguments=`.

                      Only `ConvenientService::RSpec::Matchers::Custom::DelegateTo::Entities::ExpectedArguments` instances are allowed.
                    TEXT

                    super(message)
                  end
                end

                class ArgumentsChainingIsAlreadySet < ConvenientService::Error
                  def initialize
                    message = <<~TEXT
                      Arguments chaining is already set.

                      Did you use `with_arguments` or `without_arguments` multiple times? Or a combination of them?
                    TEXT

                    super(message)
                  end
                end

                class ReturnItsValueChainingIsAlreadySet < ConvenientService::Error
                  def initialize
                    message = <<~TEXT
                      Returns its value chaining is already set.

                      Did you use `and_returns_its_value` multiple times?
                    TEXT

                    super(message)
                  end
                end

                class CallOriginalChainingIsAlreadySet < ConvenientService::Error
                  def initialize
                    message = <<~TEXT
                      Call original chaining is already set.

                      Did you use `with_calling_original` or `without_calling_original` multiple times? Or a combination of them?
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
