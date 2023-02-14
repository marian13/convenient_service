# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Errors
        class InvalidScope < ConvenientService::Error
          ##
          # @param scope [Object]
          # @return [void]
          #
          def initialize(scope:)
            message = <<~TEXT
              Scope `#{scope.inspect}` is NOT valid.

              Valid options are #{printable_valid_scopes}.
            TEXT

            super(message)
          end

          private

          ##
          # @return [String]
          #
          def printable_valid_scopes
            Constants::SCOPES.map { |scope| "`:#{scope}`" }.join(", ")
          end
        end

        class NotExportableModule < ConvenientService::Error
          ##
          # @param mod [Module]
          # @return [void]
          #
          def initialize(mod:)
            message = <<~TEXT
              Module `#{mod}` can NOT export methods.

              Did you forget to include `ConvenientService::DependencyContainer::Export` into it?
            TEXT

            super(message)
          end
        end

        class NotExportedMethod < ConvenientService::Error
          ##
          # @param method_name [String]
          # @param method_scope [Symbol]
          # @param mod [Module]
          # @return [void]
          #
          def initialize(method_name:, method_scope:, mod:)
            message = <<~TEXT
              Module `#{mod}` does NOT export method `#{method_name}` with `#{method_scope}` scope.

              Did you forget to export it from `#{mod}`? For example:

              module #{mod}
                export #{method_name}, scope: :#{method_scope} do |*args, **kwargs, &block|
                  # ...
                end
              end
            TEXT

            super(message)
          end
        end
      end
    end
  end
end
