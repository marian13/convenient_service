# frozen_string_literal: true

module ConvenientService
  module Support
    module DependencyContainer
      module Commands
        class ImportMethod < Support::Command
          include Support::Delegate

          ##
          # @!attribute [r] prepend
          #   @return [Boolean]
          #
          attr_reader :prepend

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

            exported_method
          end

          private

          ##
          # @return [Module]
          #
          def imported_scoped_methods
            @imported_scoped_methods ||= Utils::Module.fetch_own_const(importing_module, :"Imported#{imported_prefix}#{scoped_prefix}Methods") { Commands::CreateMethodsModule.call }
          end

          ##
          # @return [String]
          #
          def imported_prefix
            prepend ? "Prepended" : "Included"
          end

          ##
          # @return [String]
          #
          def scoped_prefix
            case scope
            when Constants::INSTANCE_SCOPE then "Instance"
            when Constants::CLASS_SCOPE then "Class"
            end
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
