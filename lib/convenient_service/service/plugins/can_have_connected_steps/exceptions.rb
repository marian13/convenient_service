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
            def initialize_with_kwargs(container:)
              printable_container = Utils::Class.display_name(container)

              message = <<~TEXT
                First step of `#{printable_container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{printable_container}
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
            # @param method [Symbol]
            # @return [void]
            #
            def initialize_with_kwargs(container:, method:)
              printable_container = Utils::Class.display_name(container)

              message = <<~TEXT
                First step of `#{method}` from `#{printable_container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{printable_container}
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

          class FirstConditionalGroupStepIsNotSet < ::ConvenientService::Exception
            ##
            # @param container [Class<ConvenientService::Service>]
            # @param method [Symbol]
            # @return [void]
            #
            def initialize_with_kwargs(container:, method:)
              printable_container = Utils::Class.display_name(container)

              message = <<~TEXT
                First step of `#{method}` from `#{printable_container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{printable_container}
                  # ...

                  #{method} SomeService do
                    step SomeOtherService

                    # ...
                  end

                  # ...
                end
              TEXT

              initialize(message)
            end
          end

          class ElseWithoutIf < ::ConvenientService::Exception
            ##
            # @param container [Class<ConvenientService::Service>]
            # @param method [Symbol]
            # @return [void]
            #
            def initialize_with_kwargs(container:, method:)
              printable_container = Utils::Class.display_name(container)

              message = <<~TEXT
                First step of `#{method}` from `#{printable_container}` is NOT set.

                Did you forget to use `step`? For example:

                class #{printable_container}
                  # ...

                  #{method} SomeService do
                    step SomeOtherService

                    # ...
                  end

                  # ...
                end
              TEXT

              initialize(message)
            end
          end

          class ElseIfAfterElse < ::ConvenientService::Exception
            ##
            # @param container [Class<ConvenientService::Service>]
            # @param method [Symbol]
            # @return [void]
            #
            def initialize_with_kwargs(container:, method:)
              printable_container = Utils::Class.display_name(container)

              message = <<~TEXT
                `#{method}` is called after `else_group` in `#{printable_container}`.
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
