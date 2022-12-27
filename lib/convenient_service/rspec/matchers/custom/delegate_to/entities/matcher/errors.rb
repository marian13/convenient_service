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
              end
            end
          end
        end
      end
    end
  end
end
