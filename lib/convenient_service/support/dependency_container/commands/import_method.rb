# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class ImportMethod < Support::Command
          include Support::Delegate

          ##
          # @!attribute [r] importing_module
          #   @return [Module]
          #
          attr_reader :importing_module

          ##
          # @!attribute [r] exported_method
          #   @return [ConvenientService::Support::DependencyContainer::Method]
          #
          attr_reader :exported_method

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

          ##
          # @!attribute [r] scope
          #   @return [Symbol]
          #
          delegate :scope, to: :exported_method

          ##
          # @param importing_module [Module]
          # @param exported_method [ConvenientService::Support::DependencyContainer::Method]
          # @param prepend [Boolean]
          #
          def initialize(importing_module:, exported_method:, prepend:)
            @importing_module = importing_module
            @exported_method = exported_method
            @prepend = prepend
          end

          ##
          # @return [ConvenientService::Support::DependencyContainer::Method]
          #
          def call
            import imported_scoped_methods

            exported_method.define_in_module!(imported_scoped_methods)
          end

          private

          ##
          # @return [Module]
          #
          def imported_scoped_methods
            @imported_scoped_methods ||= Commands::FetchNamespace.call(importing_module: importing_module, scope: scope, prepend: prepend)
          end

          ##
          # @return [Module, Class]
          #
          def importer
            case scope
            when Constants::INSTANCE_SCOPE then importing_module
            when Constants::CLASS_SCOPE then importing_module.singleton_class
            end
          end

          ##
          # @param mod [Module]
          # @return [Module]
          #
          def import(mod)
            prepend ? importer.prepend(mod) : importer.include(mod)
          end
        end
      end
    end
  end
end
