# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class GetNamespace < Support::Command
          ##
          # @!attribute [r] importing_module
          #   @return [Module]
          #
          attr_reader :importing_module

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          attr_reader :scope

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @param importing_module [Module]
          # @param scope [Symbol]
          # @param prepend [Boolean]
          # @return [void]
          #
          def initialize(importing_module:, scope:, prepend:)
            @importing_module = importing_module
            @scope = scope
            @prepend = prepend
          end

          ##
          # @return [Module]
          #
          def call
            Utils::Module.get_own_const(importing_module, namespace_name)
          end

          private

          ##
          # @return [Symbol]
          #
          def namespace_name
            @namespace_name ||= Commands::BuildNamespaceName.call(scope: scope, prepend: prepend)
          end
        end
      end
    end
  end
end
