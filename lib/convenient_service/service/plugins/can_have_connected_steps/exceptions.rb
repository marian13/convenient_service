# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Exceptions
          class FirstStepIsNotSet < ::ConvenientService::Exception
            def initialize_with_kwargs(container:)
              message = <<~TEXT
                First step of `#{container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{container}
                  # ...

                  step SomeService

                  # ...
                end
              TEXT

              initialize(message)
            end
          end

          class FirstGroupStepIsNotSet < ::ConvenientService::Exception
            def initialize_with_kwargs(container:)
              message = <<~TEXT
                First step of group from `#{container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{container}
                  # ...

                  group do
                    step SomeService

                    # ...
                  end

                  # ...
                end
              TEXT

              initialize(message)
            end
          end

          class EmptyExpressionHasNoResult < ::ConvenientService::Exception
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO result.
              TEXT

              initialize(message)
            end
          end

          class EmptyExpressionHasNoStatus < ::ConvenientService::Exception
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO status.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
