# frozen_string_literal: true

module ConvenientService
  module RSpec
    module Matchers
      module Classes
        module Results
          class Base
            module Exceptions
              class InvalidStep < ::ConvenientService::Exception
                ##
                # @api private
                #
                # @param step [Object] Can be any type.
                # @return [void]
                #
                def initialize_with_kwargs(step:)
                  message = <<~TEXT
                    Step `#{step}` is NOT valid.

                    `of_step` only accepts a `Class` or a `Symbol`. For example:

                    be_success.of_step(ReadFileContent)
                    be_success.of_step(:validate_path)
                    be_success.of_step(:result)

                    If you need to confirm that `result` has NO step - use `without_step` instead.

                    be_success.without_step
                  TEXT

                  initialize(message)
                end
              end

              class InvalidStepIndex < ::ConvenientService::Exception
                ##
                # @api private
                #
                # @param step_index [Object] Can be any type.
                # @return [void]
                #
                def initialize_with_kwargs(step_index:)
                  message = <<~TEXT
                    Step index `#{step_index}` is NOT valid.

                    `of_step` only accepts an `Integer` as `index`. For example:

                    be_success.of_step(ReadFileContent, index: 0)
                    be_success.of_step(:validate_path, index: 1)
                    be_success.of_step(:result, index: 2)
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
