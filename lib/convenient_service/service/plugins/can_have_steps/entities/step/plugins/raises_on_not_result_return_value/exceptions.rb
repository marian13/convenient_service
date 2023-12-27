# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveSteps
        module Entities
          class Step
            module Plugins
              module RaisesOnNotResultReturnValue
                module Exceptions
                  class ReturnValueNotKindOfResult < ::ConvenientService::Exception
                    def initialize_with_kwargs(step:, result:)
                      message = <<~TEXT
                        Return value of step `#{step.printable_service}` is NOT a `Result`.
                        It is `#{result.class}`.

                        Did you forget to call `success`, `failure`, or `error`?
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
