# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Custom
        module Results
          class Base
            module Errors
              class InvalidStep < ConvenientService::Error
                def initialize(step:)
                  message = <<~TEXT
                    Step `#{step}` is NOT valid.

                    `of_step` only accepts a Class or a Symbol. For example:

                    be_success.of_step(ReadFileContent)
                    be_success.of_step(:validate_path)
                    be_success.of_step(:result)

                    If you need to confirm that `result` has NO step - use `without_step` instead.

                    be_success.without_step
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
