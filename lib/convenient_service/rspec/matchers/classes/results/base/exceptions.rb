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
                # @param step [ConvenientService::Service, Symbol]
                # @return [void]
                #
                def initialize_with_kwargs(step:)
                  message = <<~TEXT
                    Step `#{step}` is NOT valid.

                    `of_step` only accepts a Class or a Symbol. For example:

                    be_success.of_step(ReadFileContent)
                    be_success.of_step(:validate_path)
                    be_success.of_step(:result)

                    If you need to confirm that `result` has NO step - use `without_step` instead.

                    be_success.without_step
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
