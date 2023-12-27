# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Exceptions
        class InvalidScope < ::ConvenientService::Exception
          ##
          # @param scope [Object]
          # @return [void]
          #
          def initialize_with_kwargs(scope:)
            message = <<~TEXT
              Scope `#{scope.inspect}` is NOT valid.

              Valid options are #{printable_valid_scopes}.
            TEXT

            initialize(message)
          end

          private

          ##
          # @return [String]
          #
          def printable_valid_scopes
            Constants::SCOPES.map { |scope| "`:#{scope}`" }.join(", ")
          end
        end

        class NotExportableModule < ::ConvenientService::Exception
          ##
          # @param mod [Module]
          # @return [void]
          #
          def initialize_with_kwargs(mod:)
            message = <<~TEXT
              Module `#{mod}` can NOT export methods.

              Did you forget to include `ConvenientService::DependencyContainer::Export` into it?
            TEXT

            initialize(message)
          end
        end

        class NotExportedMethod < ::ConvenientService::Exception
          ##
          # @param method_name [String]
          # @param method_scope [Symbol]
          # @param mod [Module]
          # @return [void]
          #
          def initialize_with_kwargs(method_name:, method_scope:, mod:)
            message = <<~TEXT
              Module `#{mod}` does NOT export method `#{method_name}` with `#{method_scope}` scope.

              Did you forget to export it from `#{mod}`? For example:

              module #{mod}
                export #{method_name}, scope: :#{method_scope} do |*args, **kwargs, &block|
                  # ...
                end
              end
            TEXT

            initialize(message)
          end
        end

        class NotModule < ::ConvenientService::Exception
          ##
          # @param klass [Class]
          # @return [void]
          #
          def initialize_with_kwargs(klass:)
            message = <<~TEXT
              `#{klass.inspect}` is NOT a Module.
            TEXT

            initialize(message)
          end
        end
      end
    end
  end
end
