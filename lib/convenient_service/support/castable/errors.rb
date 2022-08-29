# frozen_string_literal: true

module ConvenientService
  module Support
    module Castable
      module Errors
        class CastIsNotOverridden < ::StandardError
          def initialize(klass:)
            message = <<~TEXT
              Cast method (.cast) of `#{klass}' is NOT overridden.
            TEXT

            super(message)
          end
        end

        class FailedToCast < ::StandardError
          def initialize(other:, klass:)
            message = <<~TEXT
              Failed to cast `#{other.inspect}' into `#{klass}'.
            TEXT

            super(message)
          end
        end
      end
    end
  end
end
