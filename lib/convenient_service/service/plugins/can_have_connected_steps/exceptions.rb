# frozen_string_literal: true

##
# @author Marian Kostyk <mariankostyk13895@gmail.com>
# @license LGPLv3 <https://www.gnu.org/licenses/lgpl-3.0.html>
##

module ConvenientService
  module Service
    module Plugins
      module CanHaveConnectedSteps
        module Exceptions
          class FirstStepIsNotSet < ::ConvenientService::Exception
            ##
            # @param container [Class<ConvenientService::Service>]
            # @return [void]
            #
            # @internal
            #   TODO: Use `display_name`.
            #
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
            ##
            # @param container [Class<ConvenientService::Service>]
            # @return [void]
            #
            # @internal
            #   TODO: Use `display_name`.
            #
            def initialize_with_kwargs(container:, method:)
              message = <<~TEXT
                First step of `#{method}` from `#{container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{container}
                  # ...

                  #{method} do
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
            ##
            # @return [void]
            #
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO result.
              TEXT

              initialize(message)
            end
          end

          class EmptyExpressionHasNoOrganizer < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO organizer.
              TEXT

              initialize(message)
            end
          end

          class EmptyExpressionHasNoStatus < ::ConvenientService::Exception
            ##
            # @return [void]
            #
            def initialize_without_arguments
              message = <<~TEXT
                Empty expression has NO status.
              TEXT

              initialize(message)
            end
          end

          class ServiceHasNoSteps < ::ConvenientService::Exception
            ##
            # @param service_class [Class<ConvenientService::Service>]
            # @return [void]
            #
            def initialize_with_kwargs(service_class:)
              message = <<~TEXT
                #{Utils::Class.display_name(service_class)} has NO steps.
              TEXT

              initialize(message)
            end
          end
        end
      end
    end
  end
end
