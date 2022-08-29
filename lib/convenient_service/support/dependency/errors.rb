# frozen_string_literal: true

module ConvenientService
  module Support
    module Dependency
      module Errors
        ##
        # TODO: Specs.
        #
        class ProbablyNotSatisfiedDependency < ::StandardError
          def initialize(dependencies:, object:)
            printable_method = Commands::GetPrintableMethod.call(method: dependencies.first.method, object: object)

            printable_receivers =
              dependencies
                .map { |dependency| Commands::GetPrintableReceiver.call(receiver: dependency.receiver, object: object) }
                .join(", or ")

            message = <<~TEXT
              #{printable_method} is not defined.

              Did you forget #{printable_receivers}?
            TEXT

            super(message)
          end
        end

        ##
        # TODO: Specs.
        #
        class InstanceReceiver < ::StandardError
          def initialize(receiver:)
            message = <<~TEXT
              Dependency receiver `#{receiver}' is an instance, it should be a class or a module.
            TEXT

            super(message)
          end
        end
      end
    end
  end
end
