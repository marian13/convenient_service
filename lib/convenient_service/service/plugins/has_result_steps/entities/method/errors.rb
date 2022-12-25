# frozen_string_literal: true

module ConvenientService
  module Service
    module Plugins
      module HasResultSteps
        module Entities
          class Method
            module Errors
              class MethodHasNoOrganizer < ::ConvenientService::Error
                def initialize(method:)
                  message = <<~TEXT
                    Organizer for method `#{method.name}` is NOT assigned yet.

                    Did you forget to set it?
                  TEXT

                  super(message)
                end
              end

              class InputMethodIsNotDefinedInContainer < ::ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    `in` method `#{method.name}` is NOT defined in `#{container.klass}`.

                    Did you forget to define it?
                  TEXT

                  super(message)
                end
              end

              class OutputMethodIsDefinedInContainer < ::ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    `out` method `#{method.name}` is already defined in `#{container.klass}`.

                    Did you forget to remove it?
                  TEXT

                  super(message)
                end
              end

              class AliasInputMethodIsNotDefinedInContainer < ::ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    Alias `in` method `#{method.name}` is NOT defined in `#{container.klass}`.

                    Did you forget to define it?
                  TEXT

                  super(message)
                end
              end

              class AliasOutputMethodIsDefinedInContainer < ::ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    Alias `out` method `#{method.name}` is already defined in `#{container.klass}`.

                    Did you forget to remove it?
                  TEXT

                  super(message)
                end
              end

              class OutputMethodProc < ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    Procs are not allowed for `out` methods.
                  TEXT

                  super(message)
                end
              end

              class OutputMethodRawValue < ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    Raw values are not allowed for `out` methods.
                  TEXT

                  super(message)
                end
              end

              class MethodIsNotInputMethod < ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    Method `#{method.name}` is NOT an `in` method.
                  TEXT

                  super(message)
                end
              end

              class MethodIsNotOutputMethod < ConvenientService::Error
                def initialize(method:, container:)
                  message = <<~TEXT
                    Method `#{method.name}` is NOT an `out` method.
                  TEXT

                  super(message)
                end
              end

              class NotCompletedStep < ConvenientService::Error
                def initialize(method_name:, step:)
                  message = <<~TEXT
                    `out` method `#{method_name}` is called before its corresponding step `#{step.printable_service}` is completed.

                    Maybe it makes sense to change the steps order?
                  TEXT

                  super(message)
                end
              end

              class NotExistingStepResultDataAttribute < ConvenientService::Error
                def initialize(key:, step:)
                  message = <<~TEXT
                    Step `#{step.printable_service}` result does NOT return `#{key}` data attribute.

                    Maybe there is a typo in `out` definition?

                    Or `success` of `#{step.printable_service}` accepts a wrong key?
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
